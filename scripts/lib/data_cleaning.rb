require 'csv'

module Base
  module DataCleaning

    def clean_and_parse_string(string, row_delimiter, col_delimiter, quote_char)
      puts "stripping invalid UTF-8 characters . . ."
      cleaner_string = strip_invalid_characters(string)

      puts "parsing into grid . . ."
      csv = split_string_to_csv(cleaner_string, quote_char, row_delimiter, col_delimiter)

      puts "reconstructing format . . ."
      mass_reconstruct_quoting!(csv, quote_char)

      puts "reconstituting . . ."
      return convert_csv_to_string(csv)
    end

    def strip_invalid_characters(string)
      string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').delete("\u0000")
    end

    def split_string_to_csv(string, quote_char, row_delimiter, col_delimiter)
      lines = string.split("#{quote_char}#{row_delimiter}#{quote_char}")
      result = []
      lines.each do |line|
        row = line.split("#{quote_char}#{col_delimiter}#{quote_char}")
        result << row
      end
      return result
    end

    def reconstruct_quoting!(string, quote_char)
      string ||= ""
      s = string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      s.delete!("\u0000")
      return "" if string == " nil"
      s.delete!(quote_char)
      s.delete!("'")
      s[0] = "" if s[0] == " "
      return "#{quote_char}#{s}#{quote_char}"
    end

    def mass_reconstruct_quoting!(array_of_arrays, quote_char)
      array_of_arrays.each do |row|
        row.each_with_index do |value, i|
          if value.nil?
            row[i] = ""
            next
          end
          v = reconstruct_quoting!(value, quote_char)
          value.replace(v)
        end
      end
    end

    def convert_csv_to_string(array_of_arrays)
      lines = []
      array_of_arrays.each do |row|
        line = row.join(",")
        lines << line
      end
      return lines.join("\n")
    end

    def check_dimensions(array_of_arrays)
      report = {}
      array_of_arrays.each do |row|
        num_cols = row.count
        if report[num_cols]
          report[num_cols] += 1
        else
          report[num_cols] = 1
        end
      end
      return report
    end

    def sort_by_num_cols(array_of_strings, delimiter)
      result = {}
      array_of_strings.each do |line|
        row = line.split(delimiter)
        num_cols = row.count
        if result[num_cols]
          result[num_cols] << line
        else
          result[num_cols] = [line]
        end
      end
      return result
    end

    def delete_column!(csv_array, col_num)
      csv_array.each do |row|
        row.delete_at(col_num)
      end
    end

  end
end
