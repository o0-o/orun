# STDIN   Secure string via TTY prompt
# STDOUT  String from stdin
########################################################################

printf '%s: ' "${prompt}" >/dev/tty &&
read -s secret            </dev/tty &&
printf '\n'               >/dev/tty &&

printf '%s'   "${secret}" &&

unset "${secret}"         ||

return 1

return 0
