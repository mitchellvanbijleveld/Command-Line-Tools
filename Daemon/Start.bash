#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Start
####################################################################################################
VAR_UTILITY="Daemon"
VAR_UTILITY_SCRIPT="Start"
VAR_UTILITY_SCRIPT_VERSION="2025.01.25-0117"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo eval_FromFile exit PrintMessageV2 shift source tmux tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Start
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
source "$GLOBAL_VAR_DIR_INSTALLATION/Daemon/Daemon.bash" "$@"
# VAR_DAEMON_CONFIG_FILE
# VAR_DAEMON_EXAMPLE_FILE
# VAR_DAEMON_PID_FILE
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
    PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
        ;;
        *)
            PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
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
if DaemonHasSession; then
    PrintMessageV2 "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' is already running. Not starting again..."
    exit 1
fi
#
if DaemonConfigFileExists; then
    PrintMessageV2 "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting Session for Daemon '$VAR_DAEMON_NAME'..." 
    tmux new-session -d -s $VAR_DAEMON_NAME $(which bash) $VAR_DAEMON_CONFIG_FILE
    #
    PrintMessageV2 "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Creating PID File for Daemon '$VAR_DAEMON_NAME'..." 
    echo $(eval_FromFile "VAR_DAEMON_VERSION" $VAR_DAEMON_CONFIG_FILE; echo $VAR_DAEMON_VERSION) > "$VAR_DAEMON_PID_FILE"
else
    PrintMessageV2 "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' is not installed. Nothing to start..."
    exit 1
fi
#
if DaemonHasSession && DaemonPidFileExists; then
    PrintMessageV2 "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Started Daemon '$VAR_DAEMON_NAME' Version $(cat $VAR_DAEMON_PID_FILE)"
    exit 0
else
    PrintMessageV2 "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Something went wrong while starting Daemon '$VAR_DAEMON_NAME'..."
    exit 1
fi