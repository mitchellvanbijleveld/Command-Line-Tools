#!/bin/bash
#
####################################################################################################
####################################################################################################
# BIN HELPER UTILITY SCRIPT INFO - .Find/UtilityScriptFilePath
####################################################################################################
BIN_HELPER_UTILITY=".Find"
BIN_HELPER_UTILITY_SCRIPT="UtilityScriptFilePath"
VAR_UTILITY_SCRIPT_VERSION="2025.02.09-1424"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="basename echo exit export find printf PrintMessage realpath sed shift"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# BIN HELPER UTILITY SCRIPT INFO - .Find/UtilityScriptFilePath
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
if [[ -z $VAR_UTILITY_FOLDER_PATH ]]; then
    export VAR_UTILITY_FOLDER_PATH=$GLOBAL_VAR_DIR_INSTALLATION
    PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Export Variable 'VAR_UTILITY_FOLDER_PATH' with value '$VAR_UTILITY_FOLDER_PATH'."
else
    PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Variable 'VAR_UTILITY_FOLDER_PATH' is already set."
fi
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
Die_UnknownCommand(){
    #
    if [[ -z $@ ]] || [[ $(echo $1 | tr '[:lower:]' '[:upper:]') == $(echo $(basename $VAR_UTILITY_FOLDER_PATH) | tr '[:lower:]' '[:upper:]') ]]; then
        PrintMessage "FATAL" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Please provide a command for '${VAR_UTILITY:-mitchellvanbijleveld}'..."
    else
        PrintMessage "FATAL" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Invalid command ('$1') given for Utility '${VAR_UTILITY:-mitchellvanbijleveld}'..."
    fi
    #
    PrintMessage
    #
    PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "The following commands are available for Utility '${VAR_UTILITY:-mitchellvanbijleveld}':"
    #
    for var_utility_dir in "$VAR_UTILITY_FOLDER_PATH"/*; do
        if [[ -d  $var_utility_dir ]] || [[ -f $var_utility_dir && $var_utility_dir == *".bash" ]]; then
            var_utility=$(basename $var_utility_dir)
            PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "  - ${var_utility%.bash}"
        fi
    done
}
#
FindUtilityFolder(){
    # $1 = Name Of Utility
    if [[ -z $1 ]]; then
        return 1
    fi
    #
    PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Find Utility Folder Path '$1' in '$VAR_UTILITY_FOLDER_PATH'..."
    #
    find_result=$(find -L $VAR_UTILITY_FOLDER_PATH -mindepth 1 -maxdepth 1 -iname $1 -type d)
    #
    if [[ -d $find_result ]]; then
        VAR_UTILITY_FOLDER_PATH=$(realpath $find_result)
        VAR_UTILITY=$(echo $VAR_UTILITY_FOLDER_PATH | sed "s|$GLOBAL_VAR_DIR_INSTALLATION||; s|^/||"); VAR_UTILITY=${VAR_UTILITY:-mitchellvanbijleveld}
        #
        PrintMessage "VERBOSE" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Found Utility Folder Path '$VAR_UTILITY_FOLDER_PATH'!"
        #
        return 0
    else
        return 1
    fi
}
#
FindUtilityScriptFilePath(){
    # $1 = Name Of Utility Script
    if [[ -z $1 ]]; then
        return 1
    fi
    #
    PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Find Utility Script File Path '$1' in '$VAR_UTILITY_FOLDER_PATH'..."
    #
    find_result=$(find -L $VAR_UTILITY_FOLDER_PATH -mindepth 1 -maxdepth 1 -iname "$1.bash" -type f)
    #
    if [[ -f $find_result ]]; then
        VAR_UTILITY_SCRIPT_FILE_PATH=$(realpath $find_result)
        VAR_UTILITY_SCRIPT=$(basename $VAR_UTILITY_SCRIPT_FILE_PATH | sed 's/.bash$//')
        #
        PrintMessage "VERBOSE" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Found Utility Script File Path '$VAR_UTILITY_SCRIPT_FILE_PATH'!"
        #
        return 0
    else
        return 1
    fi
}
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
if [[ -z $@ ]]; then
    Die_UnknownCommand; exit 1
else
    PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Find Utility Script File Path with given arguments: $(echo $(printf "'%s' " "$@"))..."
fi
#
until [[ -f $VAR_UTILITY_SCRIPT_FILE_PATH ]] || [[ $# -eq 0 ]]; do
    #
    if [[ $1 == "--"* ]]; then
        PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Skip flag '$1' in arguments..."
        shift; continue
    fi
    #
    if FindUtilityFolder $1; then
        shift
    else
        break
    fi
    #
    if FindUtilityScriptFilePath $1; then
        shift
    else
        continue
    fi
    #
done
#
PrintMessage "VERBOSE" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Remaining arguments: $(echo $(printf "'%s' " "$@"))..."
#
if [[ -z $VAR_UTILITY_SCRIPT_FILE_PATH ]]; then
    Die_UnknownCommand $@
fi