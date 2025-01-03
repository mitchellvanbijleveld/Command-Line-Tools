#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .bash/AutoCompletion
####################################################################################################
VAR_UTILITY=".bash"
VAR_UTILITY_SCRIPT="AutoCompletion"
VAR_UTILITY_SCRIPT_VERSION="2024.12.19-1805"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="compgen complete echo find grep PrintMessage shift tr"
####################################################################################################
# UTILITY SCRIPT INFO - .bash/AutoCompletion
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
AutoCompleteFunction() {
    #local current_word var_utility var_utility_script VAR_UTILITY_FOLDERS VAR_UTILITY_SCRIPT_FILES VAR_SCRIPT_OPTIONS

    current_word="${COMP_WORDS[COMP_CWORD]}"
    var_utility="${COMP_WORDS[1]}"
    var_utility_script="${COMP_WORDS[2]}"


    if [[ $COMP_CWORD -eq 1 ]]; then
        VAR_UTILITY_FOLDERS=$(find "GLOBAL_VAR_DIR_INSTALLATION" -maxdepth 1 -type d ! -iname '.*' -exec basename {} \; | tr '[:upper:]' '[:lower:]')
        COMPREPLY=( $(compgen -W "$VAR_UTILITY_FOLDERS" -- "$current_word") )

    elif [[ $COMP_CWORD -eq 2 ]]; then
        var_utility_dir=$(find "GLOBAL_VAR_DIR_INSTALLATION" -maxdepth 1 -iname "$var_utility" -type d)
        if [[ -d $var_utility_dir ]]; then
            VAR_UTILITY_SCRIPT_FILES=$(find $var_utility_dir -maxdepth 1 -type f -iname "*.bash" -exec basename {} .bash \; | tr '[:upper:]' '[:lower:]')
            COMPREPLY=( $(compgen -W "$VAR_UTILITY_SCRIPT_FILES" -- "$current_word") )
        fi

    elif [[ $COMP_CWORD -ge 3 ]]; then
        var_utility_dir=$(find "GLOBAL_VAR_DIR_INSTALLATION" -maxdepth 1 -iname "$var_utility" -type d)
        var_utility_script_file=$(find $var_utility_dir -maxdepth 1 -iname "$var_utility_script.bash" -type f)
        if [[ -f $var_utility_script_file ]]; then
            VAR_SCRIPT_OPTIONS=$(grep -Eo -- '--[a-zA-Z-]+' $var_utility_script_file | tr '[:upper:]' '[:lower:]' | sort -u)
            COMPREPLY=( $(compgen -W "$VAR_SCRIPT_OPTIONS" -- "$current_word") )
        fi
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
complete -F AutoCompleteFunction mitchellvanbijleveld