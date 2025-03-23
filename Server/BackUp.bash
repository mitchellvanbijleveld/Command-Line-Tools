#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Server/BackUp
####################################################################################################
VAR_UTILITY="Server"
VAR_UTILITY_SCRIPT="BackUp"
VAR_UTILITY_SCRIPT_VERSION="2025.03.23-2202"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="cat date diff echo exit find head mkdir mktemp PrintMessage rm sed shift sort tar tr which"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS="Destination Directories MaximumBackUpFiles"
####################################################################################################
# UTILITY SCRIPT INFO - Server/BackUp
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
VAR_CONFIG_FILE_BACKUP_DIRECTORIES="$UTILITY_SCRIPT_VAR_DIR_ETC/Directories"
VAR_CONFIG_FILE_BACKUP_DESTINATION="$UTILITY_SCRIPT_VAR_DIR_ETC/Destination"
VAR_CONFIG_FILE_BACKUP_MAX_FILES="$UTILITY_SCRIPT_VAR_DIR_ETC/MaximumBackUpFiles"
#
if [[ -f "$VAR_CONFIG_FILE_BACKUP_DESTINATION" ]]; then
    VAR_BACKUP_DESTINATION_FOLDER=$(cat $VAR_CONFIG_FILE_BACKUP_DESTINATION)
fi
VAR_BACKUP_DESTINATION_FOLDER="${VAR_BACKUP_DESTINATION_FOLDER:-/_BACKUP}"
#
if [[ -f "$VAR_CONFIG_FILE_BACKUP_MAX_FILES" ]]; then
    VAR_BACKUP_MAXIMUM_FILES=$(cat $VAR_CONFIG_FILE_BACKUP_MAX_FILES)
fi
VAR_BACKUP_MAXIMUM_FILES=${VAR_BACKUP_MAXIMUM_FILES:-8}
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
CheckAndCreateDirectory(){
    # $1 = Directory To Check And/Or Create
    #
    if [[ ! -d "$1" ]]; then
        PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Create BackUp Destination Directory: '$1'..."
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which mkdir) -pv "\"$1\""
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Destination Directory already exists.."
    fi
    #
}
#
#
#
CreateBackUp(){
    # $1 = Directory To BackUp
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Creating backup for '$1'..."
    #
    BackUp_Date=$(date +'%Y%m%d')
    BackUp_Time=$(date +'%H%M')
    BackUp_FileType="tar.zstd"
    #
    BackUp_Destination_FolderPath=$(echo "$VAR_BACKUP_DESTINATION_FOLDER/$1/$BackUp_Date" | sed 's|//|/|g')
    BackUp_Destination_FilePath="$BackUp_Destination_FolderPath/$BackUp_Time.$BackUp_FileType"
    echo "$BackUp_Destination_FilePath" > "$BACKUP_TMP_FILE_BACKUP_FULLFILEPATH"
    #
    CheckAndCreateDirectory "$BackUp_Destination_FolderPath"
    #
    if [[ -f "$BackUp_Destination_FilePath" ]]; then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Skip backup for '$1' on $BackUp_Date at $BackUp_Time because this backup already exists..."
        return 9
    fi 
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which tar) --zstd -cvf "\"$BackUp_Destination_FilePath\"" "\"$1\""
    #
    if [[ $(cat $PRINTMESSAGE_TMP_FILE_EXIT_CODE) -ne 0 ]]; then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Process $(which tar) exited with non-zero exit code: $(cat $PRINTMESSAGE_TMP_FILE_EXIT_CODE)"
        return 9
    fi
    #
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Backup file created successfully."
}
#
#
#
VerifyBackUp(){
    # $1 = Directory To BackUp
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Verifying backup for '$1'..."
    #
    latest_backup=$(find "$(echo "$VAR_BACKUP_DESTINATION_FOLDER/$1" | sed 's|//|/|g')" -type f -name '*.tar.zstd' | sort -r | head -n 1)
    expected_backup=$(cat "$BACKUP_TMP_FILE_BACKUP_FULLFILEPATH")
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "File Path of the latest found backup  : $latest_backup"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "File Path of the expected last backup : $expected_backup"
    #
    if [[ "$latest_backup" != "$expected_backup" ]]; then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Latest backup does not have the expected filename. Verification Failed."
        return 9
    fi
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Verifying files in backup file '$latest_backup' with directory '$1'..."
    #
    if ! diff <(find "$1" | sed 's|^/||' | sort) <(tar -tf "$latest_backup" | sed 's|/$||' | sort); then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Verification by comparing filenames did not pass : NOT OK"
        return 9
    fi
    #
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Verification by comparing filenames passed : OK"
}
#
#
#
RotateBackUp(){
    # $1 = Directory To BackUp
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Rotating backups for '$1'..."
    #
    find "$(echo "$VAR_BACKUP_DESTINATION_FOLDER/$1" | sed 's|//|/|g')" -type f -name '*.tar.zstd' | sort -r | while IFS= read -r BackUpFile; do
        #
        ((amount_of_backups++))
        #
        if [[ $amount_of_backups -gt $VAR_BACKUP_MAXIMUM_FILES ]]; then
            PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Remove BackUp File $amount_of_backups of $VAR_BACKUP_MAXIMUM_FILES: $BackUpFile"
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which rm) -v "\"$BackUpFile\""
        else
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Keep BackUp File $amount_of_backups of $VAR_BACKUP_MAXIMUM_FILES: $BackUpFile"
        fi
    done
    #
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Rotation finished."
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
if [[ ! -f "$VAR_CONFIG_FILE_BACKUP_DIRECTORIES" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The file with directories to backup does not exist. Exiting..."
    exit 1
fi
#
CheckAndCreateDirectory "$VAR_BACKUP_DESTINATION_FOLDER"
#
while IFS= read -r DirectoryToBackUp; do
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Start BackUp Process for Directory '$DirectoryToBackUp'..."
    #
    BACKUP_TMP_FILE_BACKUP_FULLFILEPATH=$(mktemp)
    #
    if ! CreateBackUp "$DirectoryToBackUp" || ! VerifyBackUp "$DirectoryToBackUp" || ! RotateBackUp "$DirectoryToBackUp"; then
        PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Error during backup process for directory '$DirectoryToBackUp'. BackUp not completed."
        continue
    fi
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Process for Directory '$DirectoryToBackUp' finished successfully!"
    #
done < $VAR_CONFIG_FILE_BACKUP_DIRECTORIES