# LOGIN   To 1password.com $domain with $token or $password, $email and
#         $secret.
#         If $domain has been logged in previously on the host, $account
#         may be used in place of $email and $secret.
# STDOUT  1Password session token
########################################################################

# Try token
printf  ' '                       |
# Sending empty password avoids TTY prompt in case of invalid token
  op    signin                    \
        --raw                     \
        --session   "${token}"    ||
# op signin -r --session "$token"

# Fallback to full login
printf  '%s'                      \
        "${password:- }"          |
  op    signin                    \
        --raw                     \
        --shorthand "${account}"  \
        --                        \
        "${domain}.1password.com" \
        "${email}"                \
        "${secret}"               ||

# Fallback to shorthand login
printf  '%s'                      \
        "${password:- }"          |
  op    signin                    \
        --raw                     \
        --account   "${account}"  \
        --                        ||

return 1

return 0
