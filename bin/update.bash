#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/UPDATE
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="update"
VAR_UTILITY_SCRIPT_VERSION="2024.12.19-1659"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="awk cat echo git mkdir PrintMessage shasum shift which"
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
    # $3 = CURRENT SHASUM
    # $4 = PREVIOUS SHASUM
    # $3 = MESSAGE
    if [[ $2 == "" ]] && [[ $4 == "" ]] &&
       [[ $1 == "" ]] && [[ $3 == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 has been installed as an empty Utility Script for future use!"
    elif [[ $2 == "" ]] && [[ $4 == "" ]] &&
         [[ $1 != "" ]] && [[ $3 != "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 has been installed with version $1!"
    elif [[ $2 == "" ]] && [[ $4 == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]] &&
         [[ $1 != "" ]] && [[ $3 != "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 is ready to use! Version $1 is now available!"
    elif [[ $1 > $2 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 has been updated from version $2 to $1!"
        UPDATED=1
    elif [[ $1 < $2 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 has been downgraded from version $2 to $1!"
        UPDATED=1
    elif [[ $1 == $2 ]] && [[ $3 != $4 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 has a different shasum after updating (changed from $4 to $3)!"
        UPDATED=1
    elif [[ $1 == $2 ]] && [[ $3 == $4 ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$5 is already up to date ($2)!"
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
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking for updates..."
#
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
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current shasum version for Utility Script '$var_utility_script_file_basename'..."
            var_utility_script_version=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_VERSION)
            var_utility_script_shasum=$(shasum $var_utility_script_file | awk '{print $1}')
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current version for Utility Script is $var_utility_script_version"
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current shasum for Utility Script is $var_utility_script_shasum"
            echo $var_utility_script_version > "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename"
            echo $var_utility_script_shasum > "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename.shasum"
        else
            continue
        fi
    done
done
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current version and shasum for bin..."
VAR_OLD_VERSION=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld"; echo $VAR_UTILITY_SCRIPT_VERSION)
VAR_OLD_SHASUM=$(shasum "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld" | awk '{print $1}')
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current version for bin is $VAR_OLD_VERSION"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current shasum for bin is $VAR_OLD_SHASUM"
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Using command 'git' to pull the latest version..."
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which git) "-C '$GLOBAL_VAR_DIR_INSTALLATION' pull --rebase"
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting new version and shasum for bin..."
VAR_NEW_VERSION=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld"; echo $VAR_UTILITY_SCRIPT_VERSION)
VAR_NEW_SHASUM=$(shasum "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld" | awk '{print $1}')
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New version for bin is $VAR_NEW_VERSION"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New shasum for bin is $VAR_NEW_SHASUM"
#
PrintVersionComparison "$VAR_NEW_VERSION" "$VAR_OLD_VERSION" "$VAR_NEW_SHASUM" "$VAR_OLD_SHASUM" "Command Line Tools"
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
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting new version and shasum for Utility Script '$var_utility_script_file_basename'..."
            var_utility_script_version=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_VERSION)
            var_utility_script_shasum=$(shasum $var_utility_script_file | awk '{print $1}')
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New version for Utility Script is $var_utility_script_version"
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New shasum for Utility Script is $var_utility_script_shasum"
            #
            if [[ -f "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename" ]]; then
                var_utility_script_old_version=$(cat "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename")
            else
                var_utility_script_old_version=""
            fi
            #
            if [[ -f "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename.shasum" ]]; then
                var_utility_script_old_shasum=$(cat "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename.shasum")
            else
                var_utility_script_old_shasum=""
            fi
            #
            PrintVersionComparison "$var_utility_script_version" "$var_utility_script_old_version" "$var_utility_script_shasum" "$var_utility_script_old_shasum" "Utility Script $var_utility_folder_basename/$var_utility_script_file_basename"
            #
        else
            continue
        fi
    done
done
#
PrintMessage
#
if [[ $UPDATED -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools and/or Utility Scripts have been updated."
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools is already up to date!"
fi