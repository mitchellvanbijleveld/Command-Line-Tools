#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Help/Help
####################################################################################################
VAR_UTILITY="Help"
VAR_UTILITY_SCRIPT="Help"
VAR_UTILITY_SCRIPT_VERSION="2024.12.31-0125"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit PrintMessage shift tr"
####################################################################################################
# UTILITY SCRIPT INFO - Help/Help
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
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Invalid option given. Exiting..."
            exit 1
        ;;
        *)
            if [[ $HELP_VAR_UTILITY == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as HELP_VAR_UTILITY..."
                HELP_VAR_UTILITY=$var_argument_CAPS
            elif [[ $HELP_VAR_UTILITY_SCRIPT == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as HELP_VAR_UTILITY_SCRIPT..."
                HELP_VAR_UTILITY_SCRIPT=$var_argument_CAPS
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
#
##################################################
##################################################
# FIND UTILITY HELP FOLDER PATH
##################################################
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking variable HELP_VAR_UTILITY with value '$HELP_VAR_UTILITY'..."
if [[ $HELP_VAR_UTILITY == "" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No Help Utility was provided. Exiting..."
    exit 1
fi
#
if FindUtilityFolderPath "$GLOBAL_VAR_DIR_INSTALLATION/Help" "$HELP_VAR_UTILITY"; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Help Utility Folder '$HELP_VAR_UTILITY' found!"
else
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The Help Utility Folder for '$HELP_VAR_UTILITY' was not found. Exiting..."
    exit 1
fi
##################################################
# FIND UTILITY HELP FOLDER PATH
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# FIND UTILITY SCRIPT HELP FILE PATH
##################################################
if FindUtilityScriptFilePath "$VAR_UTILITY_FOLDER_PATH" "$HELP_VAR_UTILITY_SCRIPT"; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Help Utility Script File '$HELP_VAR_UTILITY_SCRIPT' found in Utility '$HELP_VAR_UTILITY'!"
elif FindUtilityScriptFilePath "$VAR_UTILITY_FOLDER_PATH" "$HELP_VAR_UTILITY"; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Utility Script '$HELP_VAR_UTILITY' found in Utility '$HELP_VAR_UTILITY'!"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Changing variable 'HELP_VAR_UTILITY_SCRIPT' from '$HELP_VAR_UTILITY_SCRIPT' to '$HELP_VAR_UTILITY'..."
elif [[ $HELP_VAR_UTILITY_SCRIPT == "" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No Help Utility Script was provided. Exiting..."
    exit 1
else
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The Help Utility Script File for '$HELP_VAR_UTILITY' '$HELP_VAR_UTILITY_SCRIPT' was not found. Exiting..."
    exit 1
fi
##################################################
# FIND UTILITY SCRIPT HELP FILE PATH
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# START HELP UTILITY SCRIPT
##################################################
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting Help Utility '$HELP_VAR_UTILITY' Script '$HELP_VAR_UTILITY_SCRIPT'..."
$(which bash) $VAR_UTILITY_SCRIPT_FILE_PATH