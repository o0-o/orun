# Authenticate  1Password.com account with --token ($1). If no token is
#               provided, look in macOS keychain for one. If token is
#               invalid or expired, fall back to password auth.
#
#               Otherwise, use --domain ($3) with --password ($1),
#               --email ($2) and --secret ($4).
#
#               If $email has been logged in previously on the host,
#               only --email ($2) and --password ($1) are necessary.
#
#               If no arguments or only --password ($1) is supplied, the
#               last login is used.
#
#               --account may also be suppied to manually define the
#               1Password account shorthand, otherwise it is derived
#               from the email address.
#
#               Note that --password ($1) may also be the session token,
#               but there is not an attempt to use --token as the
#               master password. This allows the token or password to be
#               piped to the command.
#
# STDOUT        1Password session token
########################################################################

: ${password:=$(  printf '%s' "${1}" && shift )}
: ${email:=$(     printf '%s' "${1}" && shift )}
: ${domain:=$(    printf '%s' "${1}" && shift )}
# We expect short domain, so concatenate full domain if provided
declare domain="${domain%%.*}"                                      || :
: ${secret:=$(    printf '%s' "${1}" && shift )}
# Use email instead of domain as shorthand to allow multiple accounts
# in the same domain
: ${account:=$email}
# Replace non-alphanumerica characters with _ for $OP_SESSION variable
declare account="${account//[^[:alnum:]]/_}"                        || :
# Fallback to last account that was used to sign in
: ${account:=$( "${_run}" 'json'          \
                          'latest_signin' \
                          "${XDG_CONFIG_HOME-$HOME}/.op/config" )}
# If token isn't supplied, check OS's native password manager
: ${token:=$("${_run}" credentials password "${account}" '1password.com')}
# Password may be master password or session token
: ${token:=$password}

# Attempt 1
"${_script_wrapper[@]}"                                             |
# Print token to stdout and pipe to secure local storage
tee "/dev/fd/${_stdout_alt}"                                        |
"${_run}" credentials add "${account}" '1password.com'              &&
printf  '1Password account %s authenticated on first attempt\n'     \
        "${account}"                                            >&"${_info}" ||

# Attempt 2 (stale token or password needs to be entered from TTY)
{ [ ! -z "${account:-}" ]                                           &&
  # Remove stale token if present
  : "${_run}" credentials delete "${account}" '1password.com'       &&
  # Prompt for password if not supplied
  : ${password:=$( "${_run}"  secure prompt  \
                              "Enter password for ${account}" )}    &&
  "${_script_wrapper[@]}"                                           |
  # Print token to stdout and pipe to secure local storage
  tee "/dev/fd/${_stdout_alt}"                                      |
  "${_run}" credentials add "${account}" '1password.com'            &&
  printf  '1Password account %s authenticated on second attempt\n'  \
          "${account}"                                            >&"${_info}"
}                                                                   ||

return 1

return 0
