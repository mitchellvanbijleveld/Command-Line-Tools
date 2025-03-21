#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Find/.DS_Store
####################################################################################################
VAR_UTILITY="Find"
VAR_UTILITY_SCRIPT=".DS_Store"
VAR_UTILITY_SCRIPT_VERSION="2025.03.20-1929"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit find PrintMessage pwd rm shift tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - Find/.DS_Store
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
FOUND_FILES=0
DELETED_FILES=0
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
        "--DELETE" | "--REMOVE")
            REMOVE_FILES=1
        ;;
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
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "This script will find files with the name '.DS_Store'..."
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The search directory is set to '$(pwd)'..."
PrintMessage
#
if [[ $REMOVE_FILES -eq 1 ]]; then
    #
    PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The '--delete' or '--remove' flag is passed."
    PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "This means every file found, will be removed without confirmation."
    PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Please make sure the script did not find any files that must be kept."
    PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "This can be checked by running the script without the '--delete' or '--remove' flag."
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "In order to continue, please type 'I understand.' below."
    read -p "Type your response: " MESSAGE
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "User's response is: '$MESSAGE'"
    #
    if [[ "$MESSAGE" != "I understand." ]]; then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You did not understand the warning message. Not removing any files."
        REMOVE_FILES=0
    else
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "OK, with great power... comes great responsibility. Good luck!"
    fi
    #
    PrintMessage
    #
fi
#
while IFS= read -r DS_Store; do
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Found '.DS_Store'...: $DS_Store"; ((FOUND_FILES++))
    #
    if [[ $REMOVE_FILES -eq 1 ]]; then
        #
        if [[ -f "$DS_Store" ]]; then
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which rm) -v "\"$DS_Store\""
        fi
        #
        if [[ ! -f "$DS_Store" ]]; then
            ((DELETED_FILES++))
            echo "$DS_Store" >> "$(pwd)/.REMOVED_FILES.txt"
        fi
        #
    fi
    #
done < <(find "$(pwd)" -type f -name '.DS_Store')
#
PrintMessage
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The script found $FOUND_FILES files. There were $DELETED_FILES files removed."
#
if [[ $DELETED_FILES -gt 0 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The list of removed files can be found here: $(pwd)/.REMOVED_FILES.txt"
fi
#
PrintMessage
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Done!"