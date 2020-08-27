# Print the current shell

ps -cp "$$" -o command='' |
cut -d ' ' -f '1'         |
sed 's/^-//'              || # strip args and remove leading hyphen

return 1

return 0
