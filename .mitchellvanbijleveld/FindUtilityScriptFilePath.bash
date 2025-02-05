#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/FindUtilityScriptFilePath
####################################################################################################
#VAR_UTILITY=".mitchellvanbijleveld"
#VAR_UTILITY_SCRIPT="FindUtilityScriptFilePath"
VAR_UTILITY_SCRIPT_VERSION="2025.02.04-1359"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="PrintMessage"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/FindUtilityScriptFilePath
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
#
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
FindUtilityScriptFilePath(){
    # $1 = FIND FOLDER PATH
    # $2 = FIND FILE NAME
    PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Finding Utility Script File for '$2'..."
    VAR_UTILITY_SCRIPT_FILE_PATH=$(find -L $1 -maxdepth 1 -iname "$2.bash" -type f)
    if [[ -f $VAR_UTILITY_SCRIPT_FILE_PATH ]]; then
        return 0
    else
        PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Utility Script File for '$2' not found!"
        return 1
    fi
}
export -f FindUtilityScriptFilePath
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