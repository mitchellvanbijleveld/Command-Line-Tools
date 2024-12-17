#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/UPDATE
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="update"
VAR_UTILITY_SCRIPT_VERSION="2024.12.17-1632"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="cat git PrintMessage"
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/UPDATE
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
VAR_VERSION_FILE="$GLOBAL_VAR_DIR_INSTALLATION/VERSION"
#
VAR_OLD_VERSION=$(cat $VAR_VERSION_FILE)
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
PrintVersionComparison(){
    # $1 = CURRENT VERSION
    # $2 = PREVIOUS VERSION
    # $3 = MESSAGE
    if [[ $1 > $2 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$3 has been updated from version $2 to $1!"
        UPDATED=1
    elif [[ $1 < $2 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$3 has been downgraded from version $2 to $1!"
        UPDATED=1
    elif [[ $1 = $2 ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$3 is already up to date ($2)!"
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Something is weird while comparing versions."
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
for var_utility_folder in $GLOBAL_VAR_DIR_INSTALLATION/*; do
    if [[ -d $var_utility_folder ]]; then
        var_utility_folder_basename=$(basename $var_utility_folder)
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking for Utility Scripts in Utility '$var_utility_folder_basename'..."
        mkdir "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename"
    else
        continue
    fi
    #
    for var_utility_script_file in $var_utility_folder/*; do
        if [[ -f $var_utility_script_file ]] && [[ $var_utility_script_file == *".bash" ]]; then
            var_utility_script_file_basename=$(basename $var_utility_script_file)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current version for Utility Script '$var_utility_script_file_basename'..."
            var_utility_script_version=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_VERSION)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current version for Utility Script is $var_utility_script_version"
            echo $var_utility_script_version > "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename"
        else
            continue
        fi
    done
done
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Using command 'git' to pull the latest version..."
PrintMessage "DEBUG" $(which git) -C $GLOBAL_VAR_DIR_INSTALLATION pull --rebase
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Reading new version from VERSION..."
VAR_NEW_VERSION=$(cat $VAR_VERSION_FILE)
#
PrintVersionComparison "$VAR_NEW_VERSION" "$VAR_OLD_VERSION" "Command Line Tools"
#
for var_utility_folder in $GLOBAL_VAR_DIR_INSTALLATION/*; do
    if [[ -d $var_utility_folder ]]; then
        var_utility_folder_basename=$(basename $var_utility_folder)
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking for Utility Scripts in Utility '$var_utility_folder_basename'..."
    else
        continue
    fi
    #
    for var_utility_script_file in $var_utility_folder/*; do
        if [[ -f $var_utility_script_file ]] && [[ $var_utility_script_file == *".bash" ]]; then
            var_utility_script_file_basename=$(basename $var_utility_script_file)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current version for Utility Script '$var_utility_script_file_basename'..."
            var_utility_script_version=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_VERSION)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current version for Utility Script is $var_utility_script_version"
            #
            if [[ ! -f "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename" ]]; then
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Utility Script '$var_utility_folder_basename/$var_utility_script_file_basename' has been installed with version $var_utility_script_version!"
                continue
            else
                var_utility_script_old_version=$(cat "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename")
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Previous version for Utility Script is $var_utility_script_old_version"
            fi
            #
            PrintVersionComparison "$var_utility_script_version" "$var_utility_script_old_version" "Utility Script $var_utility_folder_basename/$var_utility_script_file_basename"
            #
        else
            continue
        fi
    done
done
#
if [[ ! $UPDATED -eq 1 ]] && [[ $(cat $VAR_TMP_FILE_COMMAND_OUTPUT) == *"Already up to date."* ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools is already up to date!"
elif [[ ! $UPDATED -eq 1 ]] && [[ $(cat $VAR_TMP_FILE_COMMAND_OUTPUT) == *"Fast-forward"* ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools has been updated without version changes!"
fi