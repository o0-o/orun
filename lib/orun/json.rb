# STDOUT  Value of field ARGV (except ARGV.last) in JSON string or file
#         ARGV.last
########################################################################

require 'json'

json_string_or_file = ARGV.pop

begin
  # Accept JSON as string
  parsed = JSON.parse(json_string_or_file)
rescue
  # Or as a file
  begin
    parsed = JSON.parse( File.read(json_string_or_file) )
  rescue
    # Otherwise fail
    exit(1)
  end
end

begin
  # Navigate JSON with positional arguments
  ARGV.each do |field|
    begin
      # Field may be a string
      parsed = parsed[field]
    rescue
      # Or integer
      parsed = parsed[field.to_i]
    end
  end
  # Print results as a hash
  begin
    # Determine longest key for formatting
    longest_key_length = 0
    parsed.each do |key, value|
      if longest_key_length < key.length then
        longest_key_length = key.length
      end
    end
    # Print key and value separated by a colon
    parsed.each do |key, value|
      puts key.ljust(longest_key_length + 1) + ': ' + value
    end
  # Print results as an array
  rescue
    begin
      parsed.each do |value|
        puts value
      end
    # Print result as a string
    rescue
      puts parsed
    end
  end
rescue
  exit(1)
end

exit(0)
