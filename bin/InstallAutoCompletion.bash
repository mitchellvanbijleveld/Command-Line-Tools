#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - bin/InstallAutoCompletion
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="InstallAutoCompletion"
VAR_UTILITY_SCRIPT_VERSION="2024.12.19-1805"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit PrintMessage sed shift tr"
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
        "--REPLACE")
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Replacing file if existing..."
            VAR_REPLACE_FILE=1
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
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Current shell is not '/bin/bash'. Exiting..."
    exit 1
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
        if [[ $VAR_REPLACE_FILE -ne 1 ]]; then
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Not replacing AutoComplete file. Use '--replace' to overwrite. Exiting..."
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
sed "s|GLOBAL_VAR_DIR_INSTALLATION|$GLOBAL_VAR_DIR_INSTALLATION|g" "$GLOBAL_VAR_DIR_INSTALLATION/.bash/AutoCompletion.bash" | tee $VAR_AUTOCOMPLETE_FILE_INSTALLATION_PATH > /dev/null