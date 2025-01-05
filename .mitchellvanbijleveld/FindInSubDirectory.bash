#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/FindInSubDirectory
####################################################################################################
VAR_UTILITY=".bin"
VAR_UTILITY_SCRIPT="FindInSubDirectory"
VAR_UTILITY_SCRIPT_VERSION="2025.01.02-0018"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="basename die_UtilityNotFound die_UtilityScriptNotFound dirname echo exit FindUtilityFolderPath FindUtilityScriptFilePath mkdir mktemp PrintMessage sed shift tr unset which"
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/FindInSubDirectory
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
VAR_SUB_DIRECTORY_BASE_NAME=$(basename $0 | sed 's/.bash$//')
VAR_VAR_UTILITY_SAVED=$(basename $(dirname $0))
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
        "--SKIP-START-SCRIPT")
            VAR_SKIP_START=1
            unset VAR_SUB_DIRECTORY_BASE_NAME
        ;;
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
        ;;
        *)       
            if [[ $VAR_VAR_UTILITY == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as VAR_VAR_UTILITY..."
                VAR_VAR_UTILITY=$var_argument_CAPS
            elif [[ $VAR_VAR_UTILITY_SCRIPT == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as VAR_VAR_UTILITY_SCRIPT..."
                VAR_VAR_UTILITY_SCRIPT=$var_argument_CAPS
            else
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'. Forwarding argument to $VAR_UTILITY Utility Script..."
                VAR_UTILITY_SCRIPT_ARGUMENTS+=("$var_argument")
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
# FIND * UTILITY FOLDER PATH
##################################################
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking variable *_VAR_UTILITY with value '$VAR_VAR_UTILITY'..."
if [[ $VAR_VAR_UTILITY == "" ]]; then
    die_UtilityNotFound "No $VAR_VAR_UTILITY_SAVED Utility was provided!" "$VAR_SUB_DIRECTORY_BASE_NAME"
fi
#
if FindUtilityFolderPath "$GLOBAL_VAR_DIR_INSTALLATION/$VAR_SUB_DIRECTORY_BASE_NAME" "$VAR_VAR_UTILITY"; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$VAR_VAR_UTILITY_SAVED Utility Folder '$VAR_VAR_UTILITY' found!"
else
    die_UtilityNotFound "The $VAR_VAR_UTILITY_SAVED Utility Folder for '$VAR_VAR_UTILITY' was not found" "$VAR_SUB_DIRECTORY_BASE_NAME"
fi
##################################################
# FIND * UTILITY FOLDER PATH
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# FIND UTILITY SCRIPT * FILE PATH
##################################################
if FindUtilityScriptFilePath "$VAR_UTILITY_FOLDER_PATH" "$VAR_VAR_UTILITY_SCRIPT"; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$VAR_VAR_UTILITY_SAVED Utility Script File '$VAR_VAR_UTILITY_SCRIPT' found in Utility '$VAR_VAR_UTILITY'!"
elif FindUtilityScriptFilePath "$VAR_UTILITY_FOLDER_PATH" "$VAR_VAR_UTILITY"; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Utility Script '$VAR_VAR_UTILITY' found in Utility '$VAR_VAR_UTILITY'!"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Changing variable 'VAR_VAR_UTILITY_SCRIPT' from '$VAR_VAR_UTILITY_SCRIPT' to '$VAR_VAR_UTILITY'..."
    VAR_VAR_UTILITY_SCRIPT=$VAR_VAR_UTILITY;
elif [[ $VAR_VAR_UTILITY_SCRIPT == "" ]]; then
    die_UtilityScriptNotFound "No $VAR_VAR_UTILITY_SAVED Utility Script specified!" "$VAR_SUB_DIRECTORY_BASE_NAME"
else
    die_UtilityScriptNotFound "$VAR_VAR_UTILITY_SAVED Utility Script '$VAR_VAR_UTILITY_SCRIPT' not found within Utility '$VAR_VAR_UTILITY'!" "$VAR_SUB_DIRECTORY_BASE_NAME"
fi
##################################################
# FIND UTILITY SCRIPT * FILE PATH
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# EXPORT * UTILITY SCRIPT VARIABLES
##################################################
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Exporting Utility Script Variables..."
export UTILITY_SCRIPT_VAR_DIR_ETC="$GLOBAL_VAR_DIR_ETC/$(basename $(dirname $VAR_UTILITY_SCRIPT_FILE_PATH))/$(basename $VAR_UTILITY_SCRIPT_FILE_PATH | sed 's/.bash$//')"
#export UTILITY_SCRIPT_VAR_DIR_TMP="$GLOBAL_VAR_DIR_TMP/$(basename $(dirname $VAR_UTILITY_SCRIPT_FILE_PATH))/$(basename $VAR_UTILITY_SCRIPT_FILE_PATH | sed 's/.bash$//')"
export UTILITY_SCRIPT_VAR_DIR_TMP=$(mktemp -d "mitchellvanbijleveld-$VAR_UTILITY-$VAR_UTILITY_SCRIPT.XXXXXXXX" --tmpdir)
VAR_VAR_UTILITY=$(basename $(dirname $VAR_UTILITY_SCRIPT_FILE_PATH))
VAR_VAR_UTILITY_SCRIPT=$(basename $VAR_UTILITY_SCRIPT_FILE_PATH | sed 's/.bash$//')
##################################################
# EXPORT * UTILITY SCRIPT VARIABLES
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# CREATE * UTILITY SCRIPT DIRECTORIES
##################################################
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Creating directories..."
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Creating directory '$UTILITY_SCRIPT_VAR_DIR_ETC'..."
mkdir -p $UTILITY_SCRIPT_VAR_DIR_ETC
##################################################
# CREATE * UTILITY SCRIPT DIRECTORIES
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# START * UTILITY SCRIPT
##################################################
if [[ $VAR_SKIP_START -eq 1 ]]; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Not starting Utility Script..."
else
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting Configure Utility '$VAR_VAR_UTILITY' Script '$VAR_VAR_UTILITY_SCRIPT'..."
    $(which bash) $VAR_UTILITY_SCRIPT_FILE_PATH "${VAR_UTILITY_SCRIPT_ARGUMENTS[@]}"
fi