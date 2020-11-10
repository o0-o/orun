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
  # Print resulting JSON
  if (parsed.is_a?(Hash))
    puts parsed.to_json
  # Unless result is a single value, print as string (to remove quotes)
  else
    puts parsed.to_s
  end
rescue
  exit(1)
end

exit(0)
