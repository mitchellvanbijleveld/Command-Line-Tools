#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Server/SecurePermissions
####################################################################################################
VAR_UTILITY="Server"
VAR_UTILITY_SCRIPT="SecurePermissions"
VAR_UTILITY_SCRIPT_VERSION="2025.01.09-2010"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="chmod echo exit PrintMessage shift tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - Server/SecurePermissions
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
#
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
            if [[ $VAR_FOLDER == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as search folder..."
                VAR_FOLDER=$var_argument
            else
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
            fi
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
if [[ $VAR_FOLDER == "" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The search folder can not be empty. Exiting..."
    exit 1
fi
#
if [[ ! -d $VAR_FOLDER ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The folder '$VAR_FOLDER' does not exist. Exiting..."
    exit 1
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting to secure the folder '$(realpath $VAR_FOLDER)'..."
PrintMessage
#
find $VAR_FOLDER | while IFS= read -r var_found_item; do
    if [[ -d $var_found_item ]]; then
        PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chmod) -v 700 $var_found_item
    elif [[ -f $var_found_item ]]; then
        case $var_found_item in
            *".bash" | *".sh")
                PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chmod) -v 700 $var_found_item
            ;;
            *)
                PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chmod) -v 600 $var_found_item
            ;;
        esac   
    else
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Not a valid file or directory ($var_found_item). Skipping..."
    fi
done
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Secured the permissions of files and folders within '$(realpath $VAR_FOLDER)'!"