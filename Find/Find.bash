#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Find/Find
####################################################################################################
VAR_UTILITY="Find"
VAR_UTILITY_SCRIPT="Find"
VAR_UTILITY_SCRIPT_VERSION="2024.12.15-1510"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="clear echo find mktemp PrintMessage sed shift sudo tr wc which"
####################################################################################################
# UTILITY SCRIPT INFO - Find/Find
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
SUPPRESS_STRING="Permission denied|Operation not permitted|Invalid argument"
#
VAR_DIRS_ONLY=0
VAR_FILES_ONLY=0
#
VAR_SEARCH_QUERY=""
VAR_SEARCH_DIR=$HOME
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
        "--DIRS-ONLY") 
            if [[ $VAR_FILES_ONLY -eq 1 ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--DIRS-ONLY' was not accepted because '--FILES-ONLY' was already set. Exiting..."
                exit 1
            else
                VAR_DIRS_ONLY=1
            fi
        ;;
        "--FILES-ONLY") 
            if [[ $VAR_DIRS_ONLY -eq 1 ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--FILES-ONLY' was not accepted because '--DIRS-ONLY' was already set. Exiting..."
                exit 1
            else
                VAR_FILES_ONLY=1
            fi
        ;;
        "--SEARCH-DIR")
            if [[ $VAR_SEARCH_DIR != $HOME ]]; then
                PrintMessage "WARN" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--SEARCH-DIR' should only be set once. Overriding..,"
            fi
            VAR_SEARCH_DIR=$2           
            if [[ ! -d $VAR_SEARCH_DIR ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--SEARCH-DIR' was not given a valid existing directory ('$VAR_SEARCH_DIR'). Exiting..."
                exit 1
            fi
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Set search directory to '$VAR_SEARCH_DIR'..."
            if [[ $VAR_SEARCH_DIR == "." || $VAR_SEARCH_DIR == *".."* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Search directory real path is '$(realpath $VAR_SEARCH_DIR)'..."
            fi
        ;;
        "--WILDCARD")
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for search string with wildcards before and after..."
            SEARCH_WILDCARD=1
        ;;
        "--SUPPRESS-ERRORS")
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Suppressing warnings and errors in output..."
            SUPPRESS_PERMISSION_DENIED=1
            ;;
        "--"*)
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Invalid option given. Exiting..."
            exit 1
        ;;
        *)
            if [[ $VAR_SEARCH_QUERY == "" ]] || [[ $VAR_SEARCH_QUERY == $VAR_SEARCH_DIR ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as search string..."
                VAR_SEARCH_QUERY=$var_argument
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
# START UTILITY SCRIPT
####################################################################################################
if [[ $VAR_SEARCH_QUERY == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Search query not set! Exiting..."
    exit 1
elif [[ $VAR_SEARCH_QUERY == $VAR_SEARCH_DIR ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Search query can not be the same as search directory! Exiting..."
    exit 1
fi
#
if [[ $SEARCH_WILDCARD -eq 1 ]]; then
    VAR_SEARCH_QUERY="*$VAR_SEARCH_QUERY*"
fi
#
$(which clear)
#
if [[ $VAR_DIRS_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for directories only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    COMMAND_SUFFIX="-type d"
elif [[ $VAR_FILES_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for files only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    COMMAND_SUFFIX="-type f"
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
fi
#
PrintMessage
#
if [[ $SUPPRESS_PERMISSION_DENIED -eq 1 ]]; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Supressing '$SUPPRESS_STRING' warnings/errors..."
    PrintMessage "INFO" $(which find) "$VAR_SEARCH_DIR" -iname "$VAR_SEARCH_QUERY" $COMMAND_SUFFIX | grep -Ev "$SUPPRESS_STRING" 
else
    PrintMessage "INFO" $(which find) "$VAR_SEARCH_DIR" -iname "$VAR_SEARCH_QUERY" $COMMAND_SUFFIX
fi
#
PrintMessage
#
VAR_COUNT_FOUND_ITEMS=$(cat $VAR_TMP_FILE_COMMAND_OUTPUT | grep -Ev "$SUPPRESS_STRING" | wc -l)
VAR_COUNT_FOUND_ERRORS=$(cat $VAR_TMP_FILE_COMMAND_OUTPUT | grep -E "$SUPPRESS_STRING" | wc -l)
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Found $(echo $VAR_COUNT_FOUND_ITEMS) files/folders and $(echo $VAR_COUNT_FOUND_ERRORS) errors/warnings in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'"