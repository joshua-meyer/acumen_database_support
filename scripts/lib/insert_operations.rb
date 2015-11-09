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

    # Inserting 1 row at a time is too slow, but we need to deal with the occasional bad row.
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
            ACUMEN.exec(write_insert_query(schema, table, small_chunk))
          rescue
            yield small_chunk
          end
        end
      end
    end

  end
end
