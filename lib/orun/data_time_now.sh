# Print the current time
#
# Accepts optional format argument and defaults to YYYY-MM-DD_HH_MM_SS
################################################################################

date +"${VALS[0]-%Y-%m-%d_%H-%M-%S}" ||

return 1

return 0
