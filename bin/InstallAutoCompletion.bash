#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - bin/InstallAutoCompletion
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="InstallAutoCompletion"
VAR_UTILITY_SCRIPT_VERSION="2024.12.19-1805"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit PrintMessage sed shasum shift tr"
####################################################################################################
# UTILITY SCRIPT INFO - bin/InstallAutoCompletion
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
VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH="/etc/bash_completion.d/mitchellvanbijleveld.bash"
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
        "--IGNORE-SHELL")
            VAR_IGNORE_SHELL=1
        ;;
        "--REPLACE")
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Replacing file if existing..."
            VAR_REPLACE_FILE=1
        ;;
        "--SHOW-DIFF")
            VAR_SHOW_DIFF=1
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
if [[ $SHELL != "/bin/bash" ]]; then
    PrintMessage "INGO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current shell is not '/bin/bash'."
    if [[ $VAR_IGNORE_SHELL -eq 1 ]]; then
        PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Continuing installation becasue --ignore-shell is passed..."
    else
        PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Exiting because of unsupported shell..."
        exit 0
    fi
fi
#
if [[ ! -d "/etc/bash_completion.d" ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Directory '/etc/bash_completion.d/' does not exist. Exiting..."
    exit 1
fi
#
if [[ ! -f $VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH ]]; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "AutoComplete file does not exist..."
elif [[ -f $VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH ]]; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "AutoComplete file already exists..."
    #
    var_current_autocomplete_file=$(shasum $VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH | awk '{print $1}')
    var_updated_autocomplete_file=$(sed "s|GLOBAL_VAR_DIR_INSTALLATION|$GLOBAL_VAR_DIR_INSTALLATION|g" "$GLOBAL_VAR_DIR_INSTALLATION/.bash/AutoCompletion.bash" | shasum | awk '{print $1}')
    #
    if [[ $var_current_autocomplete_file != $var_updated_autocomplete_file ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Updated file is available." 
        #
        if [[ $VAR_SHOW_DIFF -eq 1 ]]; then
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which diff) $VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH <(sed "s|GLOBAL_VAR_DIR_INSTALLATION|$GLOBAL_VAR_DIR_INSTALLATION|g" "$GLOBAL_VAR_DIR_INSTALLATION/.bash/AutoCompletion.bash")
        else
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Use --show-diff to print the difference"
        fi
        #
        PrintMessage
        #
        if [[ $VAR_REPLACE_FILE -eq 1 ]]; then
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Replacing file as requested..."
        else
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Not replacing AutoComplete file. Use '--replace' to overwrite."
            exit 1
        fi
    else
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Installed file is the same as the latest available file. Nothing to do."
        exit 0 
    fi
    #
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Installing AutoCompletion File..."
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which sed) "'s|GLOBAL_VAR_DIR_INSTALLATION|$GLOBAL_VAR_DIR_INSTALLATION|g' '$GLOBAL_VAR_DIR_INSTALLATION/.bash/AutoCompletion.bash' | tee '$VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH'"
#
source $VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH