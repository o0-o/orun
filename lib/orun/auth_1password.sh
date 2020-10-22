# LOGIN   To 1password.com $domain with $password, $email and $secret.
#         If $domain has been logged in previously on the host, only
#         $account and $password are necessary.
# STDOUT  1Password session token
########################################################################

# Try token
printf  ' '                       |
  op    signin                    \
        --raw                     \
        --session   "${token}"    ||

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
