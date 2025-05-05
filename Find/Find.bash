#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Find/Find
####################################################################################################
VAR_UTILITY="Find"
VAR_UTILITY_SCRIPT="Find"
VAR_UTILITY_SCRIPT_VERSION="2025.03.16-2132"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="clear echo find mktemp PrintMessage sed shift sudo tr wc which"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS="Sort SuppressErrors WildCard"
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
SUPPRESS_STRING="Invalid argument|No such file or directory|Not a directory|Operation not permitted|Permission denied"
#
VAR_SEARCH_DIR=$(pwd)
#
#
#
#
#
if [[ -f "$UTILITY_SCRIPT_VAR_DIR_ETC/Sort" ]]; then
    case $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/Sort" | tr '[:lower:]' '[:upper:]') in
        0|TRUE|YES) SORT_OUTPUT=1;;
    esac
fi
#
if [[ -f "$UTILITY_SCRIPT_VAR_DIR_ETC/SuppressErrors" ]]; then
    case $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/SuppressErrors" | tr '[:lower:]' '[:upper:]') in
        0|TRUE|YES) SUPPRESS_PERMISSION_DENIED=1;;
    esac
fi
#
if [[ -f "$UTILITY_SCRIPT_VAR_DIR_ETC/WildCard" ]]; then
    case $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/WildCard" | tr '[:lower:]' '[:upper:]') in
        0|TRUE|YES) SEARCH_WILDCARD=1;;
    esac
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
for var_argument in "$@"; do
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--DIRS-ONLY" | "--SKIP-FILES") 
            if [[ $VAR_FILES_ONLY -eq 1 ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--DIRS-ONLY' was not accepted because '--FILES-ONLY' was already set. Exiting..."
                exit 1
            else
                VAR_DIRS_ONLY=1
            fi
        ;;
        "--EXCLUDE-DIR" | "--EXCLUDE-DIRECTORY")
            VAR_EXCLUDE_DIR=$2
        ;;
        "--FILES-ONLY" | "--SKIP-DIRS" | "--SKIP-DIRECTORIES") 
            if [[ $VAR_DIRS_ONLY -eq 1 ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--FILES-ONLY' was not accepted because '--DIRS-ONLY' was already set. Exiting..."
                exit 1
            else
                VAR_FILES_ONLY=1
            fi
        ;;
        "--SEARCH-DIR" | "--SEARCH-DIRECTORY")
            if [[ $VAR_SEARCH_DIR != $(pwd) ]]; then
                PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--SEARCH-DIR' should only be set once. Replacing existing value..,"
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
        "--SORT" | "--SORT-OUTPUT")
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Output Processing: Sorting output when done..."
            SORT_OUTPUT=1
        ;;
        "--SUPPRESS-ERRORS")
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Output Processing: Suppressing errors and warnings from output..."
            SUPPRESS_PERMISSION_DENIED=1
        ;;
        "--EXECUTE-COMMAND" | "--RUN-COMMAND")
            if type $2 &> /dev/null && [[ $2 == *"{}"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Running command '$2' for every found item..."
                VAR_RUN_COMMAND=$2
            else
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Given command '$2' can not be executed. Command should include '{}'. Exiting..."
                exit 1
            fi
        ;;
        "--WILDCARD" | "--WILDCARD-SEARCH")
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for search string with wildcards before and after..."
            SEARCH_WILDCARD=1
        ;;
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
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
if [[ $VAR_SEARCH_QUERY == "" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Search query not set! Exiting..."
    exit 1
elif [[ $VAR_SEARCH_QUERY == $VAR_SEARCH_DIR ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Search query can not be the same as search directory! Exiting..."
    exit 1
fi
#
if [[ $SEARCH_WILDCARD -eq 1 ]]; then
    VAR_SEARCH_QUERY="*$VAR_SEARCH_QUERY*"
fi
#
# $(which clear)
#
if [[ $VAR_EXCLUDE_DIR != "" ]]; then
    VAR_FIND_COMMAND="'$VAR_SEARCH_DIR' -path '$VAR_EXCLUDE_DIR' -prune -o -iname '$VAR_SEARCH_QUERY' -print"
else
    VAR_FIND_COMMAND="'$VAR_SEARCH_DIR' -iname '$VAR_SEARCH_QUERY'"
fi
#
if [[ $VAR_DIRS_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for directories only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND -type d"
elif [[ $VAR_FILES_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for files only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND -type f"
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
fi
#
if [[ $VAR_RUN_COMMAND != "" ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND -exec $VAR_RUN_COMMAND \;"
fi
#
PrintMessage
#
##################################################
##################################################
# PREPARE AND RUN FIND COMMAND
##################################################
VAR_FIND_COMMAND="$VAR_FIND_COMMAND 2>&1"
#
if [[ $SORT_OUTPUT -eq 1 ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND | sort"
fi
#
if [[ $SUPPRESS_PERMISSION_DENIED -eq 1 ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND | grep -Ev '$SUPPRESS_STRING'"
fi
#
VAR_TMP_FILE_COMMAND_OUTPUT=$(mktemp "mitchellvanbijleveld-$VAR_UTILITY-$VAR_UTILITY_SCRIPT.XXXXXXXX" --tmpdir)
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Saving find output to: $VAR_TMP_FILE_COMMAND_OUTPUT"
#
VAR_FIND_COMMAND="$VAR_FIND_COMMAND | tee $VAR_TMP_FILE_COMMAND_OUTPUT"
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which find) $VAR_FIND_COMMAND
#
PrintMessage
#
if [[ $GLOBAL_VAR_DRY_RUN -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No output is generated because of this search is a Dry Run. Exiting..."
    exit 0
fi
#
VAR_COUNT_FOUND_ITEMS=$(cat $VAR_TMP_FILE_COMMAND_OUTPUT | grep -Ev "$SUPPRESS_STRING" | wc -l)
VAR_COUNT_FOUND_ERRORS=$(cat $VAR_TMP_FILE_COMMAND_OUTPUT | grep -E "$SUPPRESS_STRING" | wc -l)
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Found $(echo $VAR_COUNT_FOUND_ITEMS) files/folders and $(echo $VAR_COUNT_FOUND_ERRORS) errors/warnings in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'"