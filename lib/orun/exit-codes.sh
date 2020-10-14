# Exit/return_codes
# Valid range: 0-125

declare -r             _code_success='0' #generic command success
declare -r        _code_command_fail='1' #generic command failure
declare -r            _code_no_match='2' #no regex match
declare -r   _code_updates_available='3' #software updates are available
declare -r         _code_file_exists='4' #filename conflict
declare -r           _code_auth_fail='5' #authentication failure
declare -r           _code_not_found='6' #generic not found failure
