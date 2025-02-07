#!/bin/bash
#
####################################################################################################
####################################################################################################
# BIN HELPER UTILITY SCRIPT INFO - .Find/UtilityScriptFilePath
####################################################################################################
BIN_HELPER_UTILITY=".Find"
BIN_HELPER_UTILITY_SCRIPT="UtilityScriptFilePath"
VAR_UTILITY_SCRIPT_VERSION="2025.02.07-1323"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="basename echo exit export find PrintMessage sed shift"
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
export VAR_UTILITY_FOLDER_PATH=$GLOBAL_VAR_DIR_INSTALLATION
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
    PrintMessage
    #
    PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "The following commands are available for '${VAR_UTILITY:-mitchellvanbijleveld}':"
    #
    for var_utility_dir in "$VAR_UTILITY_FOLDER_PATH"/*; do
        if [[ -d  $var_utility_dir ]] || [[ -f  $var_utility_dir && $var_utility_dir == *".bash" ]]; then
            var_utility=$(basename $var_utility_dir)
            PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "  - ${var_utility%.bash}"
        fi
    done
    #
    exit 1
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
    PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "You need to provide a command!"
    Die_UnknownCommand
fi
#
PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Find Utility Script File Path in arguments '$@'..."
#
until [[ -f $VAR_UTILITY_SCRIPT_FILE_PATH ]] || [[ $# -eq 0 ]]; do
    found_file=0; found_folder=0; last_search=$1
    #
    PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Find Utility Folder Path '$1' in '$VAR_UTILITY_FOLDER_PATH'..."
    find_folder=$(find -L $VAR_UTILITY_FOLDER_PATH -maxdepth 1 -iname $1 -type d)
    #
    if [[ -d $find_folder ]]; then
        export VAR_UTILITY_FOLDER_PATH=$find_folder
        PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Found Utility Folder Path '$VAR_UTILITY_FOLDER_PATH'!"
        found_folder=1
        unset last_search
    fi
    #
    PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Find Utility Script File Path '$1' in '$VAR_UTILITY_FOLDER_PATH'..."
    export VAR_UTILITY_SCRIPT_FILE_PATH=$(find -L $VAR_UTILITY_FOLDER_PATH -maxdepth 1 -iname "$1.bash" -type f) 
    #
    if [[ -f $VAR_UTILITY_SCRIPT_FILE_PATH ]]; then
        PrintMessage "DEBUG" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Found Utility Script File Path '$VAR_UTILITY_SCRIPT_FILE_PATH'!"
        found_file=1
        unset last_search
    fi
    #
    if [[ $1 == $2 ]]; then
        shift 2
    else
        shift
    fi
    #
    export VAR_UTILITY=$(echo $VAR_UTILITY_FOLDER_PATH | sed "s|$GLOBAL_VAR_DIR_INSTALLATION||; s|^/||"); VAR_UTILITY=${VAR_UTILITY:-mitchellvanbijleveld}
    #
    if [[ $found_folder -eq 0 && $found_file -eq 0 ]] || [[ $found_file -eq 0 && $# -eq 0 ]]; then
        if [[ -z $last_search ]]; then
            PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "please provide command for '$VAR_UTILITY'...'"
        else
            PrintMessage "INFO" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Command '$last_search' is not valid for '$VAR_UTILITY'..."
        fi
        #
        Die_UnknownCommand
        #
    fi
    #
done
#
export VAR_UTILITY_SCRIPT=$(basename $VAR_UTILITY_SCRIPT_FILE_PATH | sed 's/.bash$//')

PrintMessage "VERBOSE" "$BIN_HELPER_UTILITY" "$BIN_HELPER_UTILITY_SCRIPT" "Remaining arguments '$@'..."