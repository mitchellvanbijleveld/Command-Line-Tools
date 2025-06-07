#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Server/BackUp
####################################################################################################
VAR_UTILITY="Server"
VAR_UTILITY_SCRIPT="BackUp"
VAR_UTILITY_SCRIPT_VERSION="2025.03.24-2259"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="cat date diff echo exit find head mkdir mktemp PrintMessage rm rmdir sha256sum sed shift sort tar tr which"
UTILITY_SCRIPT_CONFIGURATION_VARS="Destination Directories MaximumBackUpFiles"
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
#
current_backup=0
skipped_backups=0
succeeded_backups=0
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
        "--ADVANCED-BACKUP-VERIFICATION")
            ADVANCED_BACKUP_VERIFICATION=1
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
PrintConfiguration(){
    PrintMessage "CONFIG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "VAR_BACKUP_DESTINATION_FOLDER : $VAR_BACKUP_DESTINATION_FOLDER"
    PrintMessage "CONFIG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "VAR_BACKUP_MAXIMUM_FILES      : $VAR_BACKUP_MAXIMUM_FILES"
    if [[ $ADVANCED_BACKUP_VERIFICATION -eq 1 ]]; then
        PrintMessage "CONFIG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "ADVANCED_BACKUP_VERIFICATION  : YES"
    else
            PrintMessage "CONFIG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "ADVANCED_BACKUP_VERIFICATION  : NO"
    fi
}
#
#
#
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
        return 95
    fi 
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which tar) --zstdd -cvf "\"$BackUp_Destination_FilePath\"" "\"$1\""
    #
    if [[ $? -ne 0 ]]; then
        return 95
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
    if [[ $ADVANCED_BACKUP_VERIFICATION -eq 1 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Verifying backup for '$1' by comparing hashes (advanced backup verification)..."
    else
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Verifying backup for '$1'..."
    fi
    #
    latest_backup=$(find "$(echo "$VAR_BACKUP_DESTINATION_FOLDER/$1" | sed 's|//|/|g')" -type f -name '*.tar.zstd' | sort -r | head -n 1)
    expected_backup=$(cat "$BACKUP_TMP_FILE_BACKUP_FULLFILEPATH")
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "File Path of the latest found backup  : $latest_backup"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "File Path of the expected last backup : $expected_backup"
    #
    if [[ "$latest_backup" != "$expected_backup" ]]; then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Latest backup does not have the expected filename. Verification Failed."
        return 95
    fi
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Comparing files and folders in backup file '$latest_backup' with directory '$1'..."
    #
    if ! diff <(tar -tf "$latest_backup" | sed 's|/$||' | sort) <(find "$1" ! -type s | sed 's|^/||' | sort); then
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Verification by comparing file and folders name did not pass : NOT OK"
        return 95
    else
        PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Comparing BackUp Files & Folders: OK"
    fi
    #
    if [[ $ADVANCED_BACKUP_VERIFICATION -eq 1 ]]; then
        #
        var_tmp_dir=$(mktemp -d)
        #
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Extracting backup '$latest_backup' to temporary folder '$var_tmp_dir' and doing a hash comparison with files in directory '$1'..."
        #
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which tar) -xvf "\"$latest_backup\"" -C "\"$var_tmp_dir\""
        #
        if ! diff <(find "$(echo "$var_tmp_dir/$1" | sed 's|//|/|g')" -type f -exec sha256sum {} + | sort | sed "s|$var_tmp_dir||") <(find "$1" -type f -exec sha256sum {} + | sort); then
            PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Advanced BackUp Verification by comparing file hashes did not pass : NOT OK"
            RemoveDirectory "$var_tmp_dir"; return 95
        else
            PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Comparing BackUp File Hashes: OK"
            RemoveDirectory "$var_tmp_dir"
        fi
        #
    fi
    #
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp verified successfully."
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
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUps rotated successfully."
}
#
#
#
RemoveEmptyDirectories(){
    # $1 = Directory To BackUp
    #
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Removing Empty BackUp Directories for '$1'..."
    #
    find "$(echo "$VAR_BACKUP_DESTINATION_FOLDER/$1" | sed 's|//|/|g')" -type d -empty | sort -r | while IFS= read -r EmptyDirectory; do
        PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Remove Empty Directory: $EmptyDirectory..."
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which rmdir) -v "\"$EmptyDirectory\""
    done
    #
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Removing empty directories finished."
}
#
#
#
RemoveDirectory(){
    # $1 = Directory To Remove
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Removing Directory '$1'..."
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which rm) -r "\"$1\""
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
if [[ $GLOBAL_VAR_DRY_RUN ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dry Run is not supported for $VAR_UTILITY/$VAR_UTILITY_SCRIPT. Exiting..."
    exit 1
else
    PrintConfiguration
fi
#
if [[ ! -f "$VAR_CONFIG_FILE_BACKUP_DIRECTORIES" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The file with directories to backup does not exist. Exiting..."
    exit 1
else
    if [[ $(cat $VAR_CONFIG_FILE_BACKUP_DIRECTORIES | wc -l) -eq 1 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "There is $(echo $(cat $VAR_CONFIG_FILE_BACKUP_DIRECTORIES | wc -l)) backup to make."
    else
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "There are $(echo $(cat $VAR_CONFIG_FILE_BACKUP_DIRECTORIES | wc -l)) backups to make."
    fi
    PrintMessage
fi
#
CheckAndCreateDirectory "$VAR_BACKUP_DESTINATION_FOLDER"
#
while IFS= read -r DirectoryToBackUp; do
    #
    if [[ $DirectoryToBackUp =~ ^# ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring Directory '$DirectoryToBackUp' because it's commented out..."
        PrintMessage
        ((skipped_backups++)); continue
    fi
    #
    ((current_backup++))
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Start BackUp Process $current_backup/$(echo $(cat $VAR_CONFIG_FILE_BACKUP_DIRECTORIES | wc -l)): Directory '$DirectoryToBackUp'..."
    #
    BACKUP_TMP_FILE_BACKUP_FULLFILEPATH=$(mktemp)
    #
    if ! CreateBackUp "$DirectoryToBackUp" || ! VerifyBackUp "$DirectoryToBackUp" || ! RotateBackUp "$DirectoryToBackUp"; then
        PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Error during backup process for directory '$DirectoryToBackUp'. BackUp not completed."
        PrintMessage
        continue
    fi
    #
    RemoveEmptyDirectories "$DirectoryToBackUp"
    #
    ((succeeded_backups++))
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "BackUp Process for Directory '$DirectoryToBackUp' completed successfully!"
    #
    PrintMessage
    #
done < $VAR_CONFIG_FILE_BACKUP_DIRECTORIES
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Done! Successfully backed up $succeeded_backups/$(echo $(cat $VAR_CONFIG_FILE_BACKUP_DIRECTORIES | wc -l)) directories. There are $skipped_backups backups skipped."