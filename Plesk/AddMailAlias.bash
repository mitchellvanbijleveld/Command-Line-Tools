#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Plesk/AddMailAlias
####################################################################################################
VAR_UTILITY="Plesk"
VAR_UTILITY_SCRIPT="AddMailAlias"
VAR_UTILITY_SCRIPT_VERSION="2024.12.19-1324"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit plesk PrintMessage shift tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS="DefaultEmailAddress"
####################################################################################################
# UTILITY SCRIPT INFO - Plesk/AddMailAlias
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
VAR_EMAIL_ADDRESS_ALIAS=$1
VAR_EMAIL_ADDRESS=$2
VAR_DEFAULT_EMAIL_ADDRESS_FILE="$VAR_UTILITY_SCRIPT_DIR_ETC/DefaultEmailAddress"
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
            die_ProcessArguments_InvalidFlag $var_argument
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
if [[ $VAR_EMAIL_ADDRESS == "" ]] && [[ -f $VAR_DEFAULT_EMAIL_ADDRESS_FILE ]]; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Email address not provided..."
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "File with default email address exists..."
    VAR_EMAIL_ADDRESS=$(cat $VAR_DEFAULT_EMAIL_ADDRESS_FILE)
fi
#
if [[ $VAR_EMAIL_ADDRESS == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Please provide an email address or set a default!"
    exit 1
fi
#
if [[ $VAR_EMAIL_ADDRESS_ALIAS == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Please provide an alias for this email address!"
    exit 1
fi
#
VAR_EMAIL_ADDRESS_NEW_WITH_ALIAS="$VAR_EMAIL_ADDRESS_ALIAS@$(echo "$VAR_EMAIL_ADDRESS" | awk -F '@' '{print $2}')"
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Adding alias '$VAR_EMAIL_ADDRESS_ALIAS' to email address '$VAR_EMAIL_ADDRESS'..."
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New email address / alias will be: '$VAR_EMAIL_ADDRESS_NEW_WITH_ALIAS'."
#
VAR_PLESK_COMMAND="bin mail -u '$VAR_EMAIL_ADDRESS' -aliases 'add:$VAR_EMAIL_ADDRESS_ALIAS'"
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which plesk) "$VAR_PLESK_COMMAND"