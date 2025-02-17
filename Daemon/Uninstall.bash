#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Install
####################################################################################################
VAR_UTILITY="Daemon"
VAR_UTILITY_SCRIPT="UnInstall"
VAR_UTILITY_SCRIPT_VERSION="2025.02.17-1733"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="awk cp echo eval_FromFile exit PrintMessage shasum shift source tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Install
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
if DaemonConfigFileExists; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' is currently installed..."
    InstalledDaemonVersion=$(eval_FromFile "VAR_DAEMON_VERSION" "$VAR_DAEMON_CONFIG_FILE"; echo $VAR_DAEMON_VERSION)
    InstalledDaemonShasum=$(shasum $VAR_DAEMON_CONFIG_FILE | awk '{print $1}')
else
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' is not currently installed. Nothing to uninstall..."
    exit 0
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Uninstalling Daemon '$VAR_DAEMON_NAME' version $InstalledDaemonVersion ($InstalledDaemonShasum)"
PrintMessage "VERBOSE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which rm) -vf $VAR_DAEMON_CONFIG_FILE