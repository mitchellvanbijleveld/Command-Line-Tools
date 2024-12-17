#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - SSH/SSH
####################################################################################################
VAR_UTILITY="SSH"
VAR_UTILITY_SCRIPT="SSH"
VAR_UTILITY_SCRIPT_VERSION="2024.12.08-0057"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="awk grep printf PrintMessage read shift ssh which"
####################################################################################################
# UTILITY SCRIPT INFO - SSH/SSH
####################################################################################################
####################################################################################################
#
#
#
#
#
####################################################################################################
####################################################################################################
# DEFAULT VARIABLES
####################################################################################################
VAR_SSH_CONFIG_FILE="$HOME/.ssh/config"
####################################################################################################
# DEFAULT VARIABLES
####################################################################################################
####################################################################################################
#
#
#
#
#
####################################################################################################
####################################################################################################
# PROCESS ARGUMENTS
####################################################################################################
for var_argument in "$@"; do
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--"*)
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Invalid option given. Exiting..."
            exit 1
        ;;
        *)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
        ;;
    esac
    #
    shift
done
####################################################################################################
# PROCESS ARGUMENTS
####################################################################################################
####################################################################################################
#
#
#
#
#
####################################################################################################
####################################################################################################
# FUNCTIONS
####################################################################################################
#
####################################################################################################
# FUNCTIONS
####################################################################################################
####################################################################################################
#
#
#
#
#
####################################################################################################
####################################################################################################
# START UTILITY SCRIPT
####################################################################################################
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking if SSH Config File exists..."
if [[ ! -f $VAR_SSH_CONFIG_FILE ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "SSH Config File does not exist. Exiting..."
    PrintMessage
    exit 1
fi
#
PrintMessage
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The following SSH Hosts are available:"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting hosts from SSH Config File..."
for var_ssh_host in $(grep "^Host " $VAR_SSH_CONFIG_FILE | awk '{print $2}'); do
    VAR_SSH_HOSTS+=($var_ssh_host)
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  [$(printf '%2d\n' ${#VAR_SSH_HOSTS[@]})] $var_ssh_host"
done
#
if [ ${#VAR_SSH_HOSTS[@]} -eq 0 ]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No SSH Hosts were found."
    PrintMessage
    exit 1
fi
#
PrintMessage
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Please enter the number of the SSH Host you want to connect to: "
read USER_INPUT_HOST
PrintMessage
#
if [[ ! $USER_INPUT_HOST =~ ^[0-9]+$ ]] || [[ $USER_INPUT_HOST -lt 1 ]] || [[ $USER_INPUT_HOST -gt ${#VAR_SSH_HOSTS[@]} ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No valid choice was made. Exiting..."
    PrintMessage
    exit 1
fi
#
VAR_SSH_HOST=${VAR_SSH_HOSTS[$((USER_INPUT_HOST - 1))]}
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Connecting to $VAR_SSH_HOST..."
$(which ssh) $VAR_SSH_HOST