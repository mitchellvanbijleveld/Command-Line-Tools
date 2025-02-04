#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/FindUtilityFolderPath
####################################################################################################
#VAR_UTILITY=".mitchellvanbijleveld"
#VAR_UTILITY_SCRIPT="FindUtilityFolderPath"
VAR_UTILITY_SCRIPT_VERSION="2025.02.04-1359"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="PrintMessage"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/FindUtilityFolderPath
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
FindUtilityFolderPath(){
    # $1 = FIND FOLDER PATH
    # $2 = FIND FOLDER NAME
    PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Finding Utility Folder for '$2' in '$1'..."
    if [[ $2 == *"/"* ]]; then
        VAR_UTILITY_FOLDER_PATH=$(find -L $1 -maxdepth 2 -ipath "*$2" -type d)
    else
        VAR_UTILITY_FOLDER_PATH=$(find -L $1 -maxdepth 1 -iname "$2" -type d)
    fi
    #
    if [[ -d $VAR_UTILITY_FOLDER_PATH ]]; then
        VAR_UTILITY_FOLDER_PATH=$(realpath $VAR_UTILITY_FOLDER_PATH)
        return 0
    else
        PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Utility Folder for '$2' not found!"
        return 1
    fi
}
export -f FindUtilityFolderPath
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