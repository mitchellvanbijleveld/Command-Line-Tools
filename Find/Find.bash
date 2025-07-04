#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Find/Find
####################################################################################################
VAR_UTILITY="Find"
VAR_UTILITY_SCRIPT="Find"
VAR_UTILITY_SCRIPT_VERSION="2025.06.07-2226"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="clear echo eval find mktemp PrintMessage sed shift sudo tr wc which"
UTILITY_SCRIPT_CONFIGURATION_VARS="ExecuteCommand Sort SuppressErrors WildCard"
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
            UTILITY_SCRIPT_VAR_Sort=1
        ;;
        "--SUPPRESS-ERRORS")
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Output Processing: Suppressing errors and warnings from output..."
            UTILITY_SCRIPT_VAR_SuppressErrors=1
        ;;
        "--EXECUTE-COMMAND" | "--RUN-COMMAND")
            if type $2 &> /dev/null && [[ $2 == *"{}"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Running command '$2' for every found item..."
                UTILITY_SCRIPT_VAR_ExecuteCommand=$2
            else
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Given command '$2' can not be executed. Command should include '{}'. Exiting..."
                exit 1
            fi
        ;;
        "--WILDCARD" | "--WILDCARD-SEARCH")
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for search string with wildcards before and after..."
            UTILITY_SCRIPT_VAR_WildCard=1
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
if [[ $UTILITY_SCRIPT_VAR_WildCard -eq 1 ]]; then
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
if [[ $UTILITY_SCRIPT_VAR_ExecuteCommand != "" ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND -exec $UTILITY_SCRIPT_VAR_ExecuteCommand \;"
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
if [[ $UTILITY_SCRIPT_VAR_Sort -eq 1 ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND | sort"
fi
#
if [[ $UTILITY_SCRIPT_VAR_SuppressErrors -eq 1 ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND | grep -Ev '$SUPPRESS_STRING'"
fi
#
#
#
if [[ $(uname) =~ Darwin ]]; then
    VAR_FIND_COMMAND="$VAR_FIND_COMMAND | grep -Ev '^/System/Volumes'"
fi
#
#
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