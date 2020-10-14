# STDOUT  'Hello, world!' or parameters separated by new line in all
#         supported scripting languages
########################################################################

set -- "${@:-Hello, world!}"

printf '%s\n'   'Shell:'                              &&
source          "${_lib_path}/out_print.sh"           &&

printf '\n%s\n' 'AWK:'                                &&
printf '%s\n'   "${@}"  |
  awk   -f      "${_lib_path}/out_print.awk"          &&

printf '\n%s\n' 'TCL:'                                &&
tclsh           "${_lib_path}/out_print.tcl"  "${@}"  &&

printf '\n%s\n' 'Perl:'                               &&
perl            "${_lib_path}/out_print.pl"   "${@}"  &&

printf '\n%s\n' 'Python:'                             &&
"${_python}"    "${_lib_path}/out_print.py"   "${@}"  &&

printf '\n%s\n' 'Ruby:'                               &&
ruby            "${_lib_path}/out_print.rb"   "${@}"  ||

{ printf '%s\n' 'Hello world failed.' >&"${_err}"; return 1; }

return 0
