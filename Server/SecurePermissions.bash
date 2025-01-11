#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Server/SecurePermissions
####################################################################################################
VAR_UTILITY="Server"
VAR_UTILITY_SCRIPT="SecurePermissions"
VAR_UTILITY_SCRIPT_VERSION="2025.01.11-0101"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="chmod echo eval exit find printf PrintMessage shift tr which"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - Server/SecurePermissions
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
            VAR_FORCE=1
        ;;
        "--GROUP")
            VAR_GROUP=$2
        ;;
        "--USER")
            VAR_USER=$2
        ;;
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
        ;;
        *)
            if [[ $VAR_FOLDER == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as search folder..."
                VAR_FOLDER=$var_argument
            else
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
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
if [[ $VAR_FOLDER == "" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The search folder can not be empty. Exiting..."
    exit 1
fi
#
if [[ ! -d $VAR_FOLDER ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The folder '$VAR_FOLDER' does not exist. Exiting..."
    exit 1
fi
#
if [[ $VAR_FORCE -eq 1 ]]; then
    VAR_COMMAND_STRING="'$VAR_FOLDER'"
else
    # VAR_COMMAND_STRING="'$VAR_FOLDER' ! -perm 600 ! -perm 700"
    VAR_COMMAND_STRING="'$VAR_FOLDER' \( -type d ! -perm 700 \) -o \( -type f ! -perm 700 -a \( -name '*.bash' -o -name '*.sh' \) \) -o \( -type f ! -perm 600 -a ! \( -name '*.bash' -o -name '*.sh' \) \)"
    # FIND:
    # FOLDERS WITHOUT PERMISSIONS 700
    # \( -type d ! -perm 700 \)
    # FILES WITHOUT PERMISSIONS 700 IF ENDING WITH .SH OR .BASH
    # \( -type f ! -perm 700 -a \( -name "*.bash" -o -name "*.sh" \) \)
    # FILES WITHOUT PERMISSION 600 NOT ENDING WITH .SH OR .BASH
    # \( -type f ! -perm 600 -a ! \( -name "*.bash" -o -name "*.sh" \) \)
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Scanning folder '$(realpath "$VAR_FOLDER")'..."; VAR_ITEM_COUNT=$(eval $(which find) $VAR_COMMAND_STRING | wc -l)
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Files found not matching secure permissions: $(echo $VAR_ITEM_COUNT)"
PrintMessage
#
if [[ $VAR_ITEM_COUNT -eq 0 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Folder seems to be secured already. Use --force to resecure the folder. Exiting..."
    exit 0
else
    max_length=$(echo -n "$(echo $VAR_ITEM_COUNT)" | wc -c)
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting to secure the folder '$(realpath "$VAR_FOLDER")'..."
#
while IFS= read -r var_found_item; do
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "$(printf "Processing file %*d of %d\n" "$max_length" "$(($VAR_PROCESSED_ITEMS + 1))" "$VAR_ITEM_COUNT"): $var_found_item"
    #  
    if [[ -d $var_found_item ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chmod) -v 700 "\"$var_found_item\""
        ((VAR_PROCESSED_ITEMS++))
    elif [[ -f $var_found_item ]]; then
        case $var_found_item in
            *".bash" | *".sh")
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chmod) -v 700 "\"$var_found_item\""
                ((VAR_PROCESSED_ITEMS++))
            ;;
            *)
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chmod) -v 600 "\"$var_found_item\""
                ((VAR_PROCESSED_ITEMS++))
            ;;
        esac   
    else
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Not a valid file or directory ($var_found_item). Skipping..."
    fi
    #
    if [[ -d $var_found_item ]] || [[ -f $var_found_item ]]; then
        if [[ $VAR_GROUP != "" ]] && [[ $VAR_USER != "" ]]; then
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chown) -v $VAR_USER:$VAR_GROUP "'$var_found_item'"
        elif [[ $VAR_USER != "" ]]; then
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which chown) -v $VAR_USER "'$var_found_item'"
        fi
    fi
done < <(eval $(which find) $VAR_COMMAND_STRING)
#
PrintMessage
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Secured the permissions of $VAR_PROCESSED_ITEMS/$(echo $VAR_ITEM_COUNT) items within '$(realpath "$VAR_FOLDER")'!"