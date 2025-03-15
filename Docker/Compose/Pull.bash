#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Docker/Compose/Pull
####################################################################################################
VAR_UTILITY="Docker/Compose"
VAR_UTILITY_SCRIPT="Pull"
VAR_UTILITY_SCRIPT_VERSION="2025.03.16-0007"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="cd docker echo exit PrintMessage pwd shift tr which"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS="Directories"
####################################################################################################
# UTILITY SCRIPT INFO - Docker/Compose/Pull
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
FILE_PULL_DIRECTORIES="$UTILITY_SCRIPT_VAR_DIR_ETC/Directories"
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
if [[ ! -f $FILE_PULL_DIRECTORIES ]]; then
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No directories are configured. Exiting..."
    exit 0
fi
#
while IFS= read -r pull_directory; do
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Read Directory From Configuration File: '$pull_directory'..."

        if [[ ! -d "$pull_directory" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Specified Directory does not exist. Skipping..."
        PrintMessage
        continue
    fi
    #
    if [[ ! -f "$pull_directory/docker-compose.yml" && ! -f "$pull_directory/docker-compose.yaml" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - No Docker Compose file present. Skipping..."
        PrintMessage
        continue
    fi
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Changing directories to '$pull_directory'..."
    cd "$pull_directory"
    #
    if [[ "$(pwd)" != "$pull_directory" ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Could not change directories. Skipping..."
        PrintMessage
        continue
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Successfully changed directories!"
    fi
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Start Docker Compose Pull in $(pwd)..."
    PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which docker) compose pull
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Done!"
    #
done < $FILE_PULL_DIRECTORIES