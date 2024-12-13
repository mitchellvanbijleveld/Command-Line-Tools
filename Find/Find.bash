#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Find/Find
####################################################################################################
VAR_UTILITY="Find"
VAR_UTILITY_SCRIPT="Find"
VAR_UTILITY_SCRIPT_VERSION="2024.12.12-1816"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="clear echo find PrintMessage sed shift sudo tr"
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
# VARIABLES
####################################################################################################
VAR_FLAGS="--DIRS-ONLY --FILES-ONLY --SEARCH-DIR"
#
VAR_DIRS_ONLY=0
VAR_FILES_ONLY=0
#
VAR_SEARCH_QUERY=""
VAR_SEARCH_DIR=$HOME
####################################################################################################
# VARIABLES
####################################################################################################
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
        "--"*)
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Invalid option given. Exiting..."
            exit 1
        ;;
        *)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
        ;;
    esac
    #
    if [[ $VAR_FLAGS != *"$var_argument_CAPS"* && $VAR_SEARCH_QUERY == "" ]] || [[ $VAR_SEARCH_QUERY == $VAR_SEARCH_DIR ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as search string..."
        VAR_SEARCH_QUERY=$var_argument
    fi
    #
    shift
done
#
if [[ $VAR_SEARCH_QUERY == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Search query not set! Exiting..."
    exit 1
fi
#
$(which clear)
#
if [[ $VAR_DIRS_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for directories only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    PrintMessage
    PrintMessage "INFO" $(which find) "$VAR_SEARCH_DIR" -iname "*$VAR_SEARCH_QUERY*" -type d
elif [[ $VAR_FILES_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for files only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    PrintMessage
    PrintMessage "INFO" $(which find) "$VAR_SEARCH_DIR" -iname "*$VAR_SEARCH_QUERY*" -type f
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    PrintMessage
    PrintMessage "INFO" $(which find) "$VAR_SEARCH_DIR" -iname "*$VAR_SEARCH_QUERY*"
fi