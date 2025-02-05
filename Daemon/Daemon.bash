#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Daemon
####################################################################################################
VAR_UTILITY="Daemon"
VAR_UTILITY_SCRIPT="Daemon"
VAR_UTILITY_SCRIPT_VERSION="2025.01.25-0059"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit mkdir PrintMessage shift tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
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
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--"*)
            # die_ProcessArguments_InvalidFlag $var_argument
            return 0
        ;;
        *)
            if [[ $VAR_DAEMON_NAME == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as VAR_DAEMON_NAME..."
                VAR_DAEMON_NAME=$var_argument
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
# DEFAULT VARIABLES
####################################################################################################
VAR_DAEMON_CONFIG_FILE="$GLOBAL_VAR_DIR_ETC/$VAR_UTILITY/$VAR_DAEMON_NAME"
VAR_DAEMON_EXAMPLE_FILE="$GLOBAL_VAR_DIR_INSTALLATION/$VAR_UTILITY/Examples/$VAR_DAEMON_NAME"
VAR_DAEMON_PID_FILE="$GLOBAL_VAR_DIR_TMP/$VAR_UTILITY/$VAR_DAEMON_NAME"
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
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which mkdir) -pv "$GLOBAL_VAR_DIR_ETC/$VAR_UTILITY"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which mkdir) -pv "$GLOBAL_VAR_DIR_TMP/$VAR_UTILITY"
#
DaemonConfigFileExists(){
    if [[ -f $VAR_DAEMON_CONFIG_FILE ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Config File for Daemon '$VAR_DAEMON_NAME' is installed in: '$VAR_DAEMON_CONFIG_FILE'"
        return 0
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Config File for Daemon '$VAR_DAEMON_NAME' not installed."
        return 1
    fi
}
export -f DaemonConfigFileExists
#
DaemonExampleFileExists(){
    if [[ -f $VAR_DAEMON_EXAMPLE_FILE ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Example Deamon '$VAR_DAEMON_NAME' is available!"
        return 0
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Example Deamon '$VAR_DAEMON_NAME' does not exist."
        return 1
    fi
}
export -f DaemonExampleFileExists
#
DaemonPidFileExists(){
    if [[ -f $VAR_DAEMON_PID_FILE ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "PID File for Daemon '$VAR_DAEMON_NAME' is located in: '$VAR_DAEMON_PID_FILE'"
        return 0
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "PID File for Daemon '$VAR_DAEMON_NAME' is absent."
        return 1
    fi
}
export -f DaemonPidFileExists
#
DaemonHasSession(){
    if tmux has-session -t $VAR_DAEMON_NAME 2>/dev/null; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Active Session for Daemon '$VAR_DAEMON_NAME' is running!"
        return 0
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Active Session for Daemon '$VAR_DAEMON_NAME' does not exist."
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
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No Daemon specified. Exiting..."
    exit 1
fi