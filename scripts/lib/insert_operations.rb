require_relative 'base.rb'
require File.expand_path("../../initializers/database_connection.rb", __FILE__)

module Base
  module InsertOperations

    def first_line_of_insert_query(schema, table)
      query_results = query_for_list_of_columns_in_table(schema, table)
      headers = []
      query_results.each do |r|
        headers << r["column_name"]
      end
      "insert into #{schema}.#{table} (#{headers.join(", ")}) values"
    end

    def line_of_insert_query_body(array, transform)
      return "(#{array.map { |v| transform.call(v) }.join(", ")})"
    end

    def body_of_insert_query(array_of_arrays)
      p = Proc.new do |string|
        next "NULL" if string.nil? or string.length == 0
        next "'#{string}'"
      end
      array_of_arrays.map { |row| line_of_insert_query_body(row, p) }.join(",\n")
    end

    def write_insert_query(schema, table, array_of_arrays)
      first_line_of_insert_query(schema, table) + "\n" + body_of_insert_query(array_of_arrays)
    end

    def insert_defensively(schema, table, array_of_arrays)
      bads0 = []
      insert_in_batches(schema, table, array_of_arrays, 10000) { |b| bads0 << b }
      bads1 = []
      insert_in_batches(schema, table, bads0, 1000) { |b| bads1 << b }
      bads2 = []
      insert_in_batches(schema, table, bads1, 100) { |b| bads2 << b }
      bads3 = []
      insert_in_batches(schema, table, bads2, 10) { |b| bads3 << b }
      insert_in_batches(schema, table, bads2, 1) { |b| yield b }
    end

    def insert_yield_bad_rows(schema, table, array_of_arrays)
      batch_size = 10000
      input_chunks = [array_of_arrays]
      until batch_size == 1
        bads = []
        insert_in_batches(schema, table, input_chunks, batch_size) { |b| bads << b }
        input_chunks = bads
        batch_size /= 10
      end
      insert_in_batches(schema, table, input_chunks, batch_size) { |b| yield b[0] }
    end

    def insert_in_batches(schema, table, array_of_arrays, batch_size)
      array_of_arrays.each do |big_chunk|
        small_chunks = big_chunk.each_slice(batch_size).to_a
        small_chunks.each do |small_chunk|
          begin
            ACUMEN.exec(write_insert_query(schema, table, chunk))
          rescue
            yield chunk
          end
        end
      end
    end

  end
end
