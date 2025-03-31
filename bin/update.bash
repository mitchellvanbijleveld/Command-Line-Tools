#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/UPDATE
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="update"
VAR_UTILITY_SCRIPT_VERSION="2025.03.24-0034"
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
        "--FORCE")
            FORCE_UPDATE=1
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
WriteUtilityScriptInfo(){
    mkdir -p "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename"
    var_utility_script_file_basename=$(basename $var_utility_script_file)
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current version..."
    var_utility_script_version=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_VERSION)
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current shasum..."
    var_utility_script_shasum=$(shasum $var_utility_script_file | awk '{print $1}')
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current version is $var_utility_script_version"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current shasum is $var_utility_script_shasum"
    echo $var_utility_script_version > "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename"
    echo $var_utility_script_shasum > "$UTILITY_SCRIPT_VAR_DIR_TMP/$var_utility_folder_basename/$var_utility_script_file_basename.shasum"
}
#
CompareUtilityScriptInfo(){
    var_utility_script_file_basename=$(basename $var_utility_script_file)
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting new version..."
    var_utility_script_version=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_VERSION)
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting new shasum..."
    var_utility_script_shasum=$(shasum $var_utility_script_file | awk '{print $1}')
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New version is $var_utility_script_version"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New shasum is $var_utility_script_shasum"
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
}
#
PrintVersionComparison(){
    # $1 = CURRENT VERSION
    # $2 = PREVIOUS VERSION
    # $3 = CURRENT SHASUM
    # $4 = PREVIOUS SHASUM
    # $5 = MESSAGE
    if [[ $2 == "" ]] && [[ $4 == "" ]] &&
       [[ $1 == "" ]] && [[ $3 == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has been installed as an empty Utility Script for future use!"
    elif [[ $2 == "" ]] && [[ $4 == "" ]] &&
         [[ $1 != "" ]] && [[ $3 != "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has been installed with version $1!"
    elif [[ $2 == "" ]] && [[ $4 == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]] &&
         [[ $1 != "" ]] && [[ $3 != "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 is ready to use! Version $1 is now available!"
    elif [[ $2 != "" ]] && [[ $4 != "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]] &&
       [[ $1 == "" ]] && [[ $3 == "da39a3ee5e6b4b0d3255bfef95601890afd80709" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 version $2 has been replaced by an empty Utility Script for future use!"
    elif [[ $2 != "" ]] && [[ $4 != "" ]] &&
         [[ $1 == "" ]] && [[ $3 == "" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has been removed!"
    elif [[ $2 == "" ]] && [[ $4 != "" ]] &&
         [[ $1 == "" ]] && [[ $3 == "" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has been removed!"
    elif [[ $1 > $2 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has been updated from version $2 to $1!"
        UPDATED=1
    elif [[ $1 < $2 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has been downgraded from version $2 to $1!"
        UPDATED=1
    elif [[ $1 == $2 ]] && [[ $3 != $4 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $5 has a different shasum after updating (changed from $4 to $3)!"
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
PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current versions and hashes for all utility scripts..."
ForEachUtilityScript WriteUtilityScriptInfo
#
PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting current version and shasum for bin..."
VAR_OLD_VERSION=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld"; echo $VAR_UTILITY_SCRIPT_VERSION)
VAR_OLD_SHASUM=$(shasum "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld" | awk '{print $1}')
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current version for bin is $VAR_OLD_VERSION"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current shasum for bin is $VAR_OLD_SHASUM"
#
PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Pull git repository..."
if [[ $FORCE_UPDATE -eq 1 ]]; then
    echo; echo; echo
    echo "!!!!! FORCING UPDATE !!!!!"
    $(which git) -C $GLOBAL_VAR_DIR_INSTALLATION pull --rebase
    echo "!!!!! FORCING UPDATE !!!!!"
    echo; echo; echo
else
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which git) -C $GLOBAL_VAR_DIR_INSTALLATION pull --rebase
fi
#
if [[ $? -ne 0 ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Could not update the Git Repository. Exiting..."
    exit 1
fi
#
PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting new version and shasum for bin..."
VAR_NEW_VERSION=$(eval_FromFile "VAR_UTILITY_SCRIPT_VERSION" "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld"; echo $VAR_UTILITY_SCRIPT_VERSION)
VAR_NEW_SHASUM=$(shasum "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld" | awk '{print $1}')
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New version for bin is $VAR_NEW_VERSION"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "New shasum for bin is $VAR_NEW_SHASUM"
#
PrintVersionComparison "$VAR_NEW_VERSION" "$VAR_OLD_VERSION" "$VAR_NEW_SHASUM" "$VAR_OLD_SHASUM" "Command Line Tools"
#
PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting updated versions and hashes for all utility scripts..."
ForEachUtilityScript CompareUtilityScriptInfo
#
PrintMessage
#
if [[ $UPDATED -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools and/or Utility Scripts have been updated."
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools is already up to date!"
fi