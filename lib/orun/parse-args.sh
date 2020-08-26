# Parse orun arguments

# Set parsing variables
declare -a  LIB_ILLEGAL_CHARS=('.' '/') &&
declare     COMMAND_LIB="orun"          &&
declare     BUILDING_COMMAND_LIB=0      &&  #true
declare -a  OPTS                        &&
declare -a  VALS                        &&

declare EXTS_VALID_RE="("                                         &&
for EXT in "${EXTS_VALID[@]}"; do EXTS_VALID_RE+="${EXT}|"; done  &&
# Replace last | with )
EXTS_VALID_RE="${EXTS_VALID_RE:0:$((${#EXTS_VALID_RE}-1))})"      &&

declare LIB_ILLEGAL_RE="["                                                &&
for CHAR in "${LIB_ILLEGAL_CHARS[@]}"; do LIB_ILLEGAL_RE+="${CHAR}"; done &&
LIB_ILLEGAL_RE="${LIB_ILLEGAL_RE}]"                                       ||

{ printf '%s\n' 'Failed to set parsing variables.' >&2; return 1; }

# Parse arguments into options, subcommands and values
while [ ! -z "${1-}" ]; do

  # Respect --
  { [ "${1}" = "--" ] &&
    shift             &&
    BUILDING_COMMAND_LIB=1 #false
  } ||

  # Store optional arguments (preceded by hyphens)
  { printf "${1}" | grep -q "^-"  &&
    OPTS+=("${1}")                &&
    shift
  } ||

  # Build subcommands as they correspond to libraries
  { ( exit "${BUILDING_COMMAND_LIB}" )                  &&
    ! printf '%s' "${1}" | egrep -q "${LIB_ILLEGAL_RE}" &&
    [ -f  "$( ls "${__LIB_PATH}/${COMMAND_LIB}_$1"* 2>/dev/null  |
              egrep -m '1' ".*\.${EXTS_VALID_RE}")" ]   &&
    COMMAND_LIB+="_$1"                                  &&
    shift
  } ||

  # Additional arguments are values for the subcommand
  { VALS+=("${1}")  &&
    shift           &&
    BUILDING_COMMAND_LIB=1 #false
  } ||

  { printf '%s\n' "Failed to parse argument: ${1}" >&2; return 1; }

done                          ||
{ printf '%s\n' "Failed to parse arguments." >&2; return 1; }

[ "${COMMAND_LIB}" = 'orun' ] &&
{ printf '%s\n' "Invalid subcommand." >&2; return 1; }

# Append piped data to values
[ -p /dev/stdin ]   &&
{ while read PIPE; do
    VALS+=("${PIPE}")
  done ||
  { printf '%s\n' "Failed to process pipe." >&2; return 1; }
}                   ||
[ ! -p /dev/stdin ] ||

return 1

return 0
