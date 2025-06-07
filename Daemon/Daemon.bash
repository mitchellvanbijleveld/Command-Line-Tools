#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Daemon
####################################################################################################
DAEMON="Daemon"
DAEMON_HELPER="Helper"
VAR_UTILITY_SCRIPT_VERSION="2025.04.07-2343"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="basename echo exit mkdir PrintMessage realpath shift tr"
UTILITY_SCRIPT_CONFIGURATION_VARS=""
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Daemon
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
    PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--"*)
            # die_ProcessArguments_InvalidFlag $var_argument
            return 0
        ;;
        *)
            if [[ $VAR_DAEMON_NAME == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Setting '$var_argument' as VAR_DAEMON_NAME..."
                VAR_DAEMON_NAME=$var_argument
            else
                PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Ignoring argument '$var_argument'..."
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
# DEFAULT VARIABLES
####################################################################################################
if [[ -f $VAR_DAEMON_NAME ]]; then
    PrintMessage "VERBOSE" "$DAEMON" "$DAEMON_HELPER" "Given Daemon '$VAR_DAEMON_NAME' is a file..."
    PrintMessage "VERBOSE" "$DAEMON" "$DAEMON_HELPER" "Daemon File Path: '$(realpath $VAR_DAEMON_NAME)'..."
    VAR_DAEMON_CONFIG_FILE="$GLOBAL_VAR_DIR_ETC/$DAEMON/$(basename $VAR_DAEMON_NAME)"
    VAR_DAEMON_EXAMPLE_FILE="$(realpath $VAR_DAEMON_NAME)"
    VAR_DAEMON_NAME="$(basename $VAR_DAEMON_NAME)" # In case daemon name is './daemon_name', strip relative path and set daemon name to 'daemon_name'
else
    VAR_DAEMON_CONFIG_FILE="$GLOBAL_VAR_DIR_ETC/$DAEMON/$VAR_DAEMON_NAME"
    VAR_DAEMON_EXAMPLE_FILE="$GLOBAL_VAR_DIR_INSTALLATION/$DAEMON/Examples/$VAR_DAEMON_NAME"
fi
#
VAR_DAEMON_PID_FILE="$GLOBAL_VAR_DIR_TMP/$DAEMON/$VAR_DAEMON_NAME"
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
# FUNCTIONS
####################################################################################################
PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" $(which mkdir) -pv "$GLOBAL_VAR_DIR_ETC/$DAEMON"
PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" $(which mkdir) -pv "$GLOBAL_VAR_DIR_TMP/$DAEMON"
#
DaemonConfigFileExists(){
    if [[ -f $VAR_DAEMON_CONFIG_FILE ]]; then
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Config File for Daemon '$VAR_DAEMON_NAME' is installed in: '$VAR_DAEMON_CONFIG_FILE'"
        return 0
    else
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Config File for Daemon '$VAR_DAEMON_NAME' not installed."
        return 1
    fi
}
export -f DaemonConfigFileExists
#
DaemonExampleFileExists(){
    if [[ -f $VAR_DAEMON_EXAMPLE_FILE ]]; then
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Example Deamon '$VAR_DAEMON_NAME' is available!"
        return 0
    else
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Example Deamon '$VAR_DAEMON_NAME' does not exist."
        return 1
    fi
}
export -f DaemonExampleFileExists
#
DaemonPidFileExists(){
    if [[ -f $VAR_DAEMON_PID_FILE ]]; then
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "PID File for Daemon '$VAR_DAEMON_NAME' is located in: '$VAR_DAEMON_PID_FILE'"
        return 0
    else
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "PID File for Daemon '$VAR_DAEMON_NAME' is absent."
        return 1
    fi
}
export -f DaemonPidFileExists
#
DaemonHasSession(){
    if tmux has-session -t $VAR_DAEMON_NAME 2>/dev/null; then
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Active Session for Daemon '$VAR_DAEMON_NAME' is running!"
        return 0
    else
        PrintMessage "DEBUG" "$DAEMON" "$DAEMON_HELPER" "Active Session for Daemon '$VAR_DAEMON_NAME' does not exist."
        return 1
    fi
}
export -f DaemonHasSession
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
if [[ $VAR_DAEMON_NAME == "" ]]; then
    PrintMessage "FATAL" "$DAEMON" "$DAEMON_HELPER" "No Daemon specified. Exiting..."
    exit 1
fi