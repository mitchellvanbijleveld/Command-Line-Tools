#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Find/Find
####################################################################################################
VAR_UTILITY="Find"
VAR_UTILITY_SCRIPT="Find"
VAR_UTILITY_SCRIPT_VERSION="2024.12.10-0059"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="clear echo find PrintMessage sed sudo"
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
VAR_SEARCH_QUERY=$@
VAR_SEARCH_DIR=$HOME
####################################################################################################
# VARIABLES
####################################################################################################
####################################################################################################
for var_argument in $VAR_SEARCH_QUERY; do
    shift
    if [[ $VAR_FLAGS =~ (^|[[:space:]])$var_argument([[:space:]]|$) ]]; then
        VAR_SEARCH_QUERY=$(echo $VAR_SEARCH_QUERY | sed -E "s/$var_argument[ ]*//")
    fi
    #
    case $var_argument in
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
            if [[ ! -d $1 ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Argument '--SEARCH-DIR' was not given a valid existing directory ($1). Exiting..."
                exit 1
            fi
            VAR_SEARCH_DIR=$1
            VAR_SEARCH_QUERY=$(echo $VAR_SEARCH_QUERY | sed -E "s|[ ]*$VAR_SEARCH_DIR||")
            ;;
        "--"*) PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Invalid option given. Exiting..."; exit 1;;
    esac
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
    $(which sudo) $(which find) "$VAR_SEARCH_DIR" -iname "*$VAR_SEARCH_QUERY*" -type d
elif [[ $VAR_FILES_ONLY -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching for files only in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    PrintMessage
    $(which sudo) $(which find) "$VAR_SEARCH_DIR" -iname "*$VAR_SEARCH_QUERY*" -type f
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Searching in '$VAR_SEARCH_DIR' for '$VAR_SEARCH_QUERY'..."
    PrintMessage
    $(which sudo) $(which find) "$VAR_SEARCH_DIR" -iname "*$VAR_SEARCH_QUERY*"
fi