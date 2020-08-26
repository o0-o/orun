# Proof of Concept

: "${VALS[0]:=Hello, world!}"

printf '%-8s' 'Shell:'                                  &&
source      "${__LIB_PATH}/out_print.sh"                &&

printf '%-8s' 'AWK:'                                    &&
printf '%-8s' "${VALS[@]-}" |
  awk -f      "${__LIB_PATH}/out_print.awk"             &&

printf '%-8s' 'TCL:'                                    &&
tclsh       "${__LIB_PATH}/out_print.tcl" "${VALS[@]-}" &&

printf '%-8s' 'Perl:'                                   &&
perl        "${__LIB_PATH}/out_print.pl"  "${VALS[@]-}" &&

printf '%-8s' 'Python:'                                 &&
"${PYTHON}" "${__LIB_PATH}/out_print.py"  "${VALS[@]-}" &&

printf '%-8s' 'Ruby:'                                   &&
ruby        "${__LIB_PATH}/out_print.rb"  "${VALS[@]-}" ||

return 1

return 0
