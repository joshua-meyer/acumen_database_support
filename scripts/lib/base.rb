module Base

  DEFAULT_SCHEMAS = ["information_schema", "pg_catalog"]
  RAW_CSVS_FOLDER = File.expand_path("../raw_csvs/") + "/"

  def query_for_list_of_table_schemas
    ACUMEN.exec("SELECT DISTINCT table_schema FROM information_schema.columns")
  end

  def query_for_list_of_tables_in_schema(schema_name)
    ACUMEN.exec("SELECT DISTINCT table_name FROM information_schema.columns WHERE table_schema='#{schema_name}' ORDER BY table_name")
  end

  def query_for_list_of_columns_in_table(schema_name, table_name)
    ACUMEN.exec("SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = '#{schema_name}' and table_name = '#{table_name}' ORDER BY ordinal_position")
  end

  def get_input(message)
    puts message
    return gets.chomp
  end

  def keep_asking_until_you_get_a_valid_response(message, condition)
    loop do
      response = get_input(message)
      return response if condition.call(response)
      puts "Sorry, that's not a valid response."
    end
  end

  def csv_files
    Dir.entries(RAW_CSVS_FOLDER).reject { |f| f[0] == "." }.map { |f| RAW_CSVS_FOLDER + f }
  end

end
