# Proof of Concept

: "${VALS[0]:=Hello, world!}"

printf '%s:\t' 'Shell'                                  &&
source      "${__LIB_PATH}/out_print.sh"                &&

printf '%s:\t' 'AWK'                                    &&
printf '%s' "${VALS[@]-}" |
  awk -f      "${__LIB_PATH}/out_print.awk"             &&

printf '%s:\t' 'TCL'                                    &&
tclsh       "${__LIB_PATH}/out_print.tcl" "${VALS[@]-}" &&

printf '%s:\t' 'Perl'                                   &&
perl        "${__LIB_PATH}/out_print.pl"  "${VALS[@]-}" &&

printf '%s:\t' 'Python'                                 &&
"${PYTHON}" "${__LIB_PATH}/out_print.py"  "${VALS[@]-}" &&

printf '%s:\t' 'Ruby'                                   &&
ruby        "${__LIB_PATH}/out_print.rb"  "${VALS[@]-}" ||

return 1

return 0
