#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Daemon/Install
####################################################################################################
VAR_UTILITY="Daemon"
VAR_UTILITY_SCRIPT="Install"
VAR_UTILITY_SCRIPT_VERSION="2025.01.07-0031"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="awk cp echo eval_FromFile exit PrintMessage shasum shift tr"
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
if [[ ! -f $VAR_DAEMON_EXAMPLE_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' does not exist as an example. Exiting..."
    exit 1
fi
#
ExampleDaemonVersion=$(eval_FromFile "VAR_DAEMON_VERSION" "$VAR_DAEMON_EXAMPLE_FILE"; echo $VAR_DAEMON_VERSION)
ExampleDaemonShasum=$(shasum $VAR_DAEMON_EXAMPLE_FILE | awk '{print $1}')
#
if [[ -f $VAR_DAEMON_CONFIG_FILE ]]; then
    InstalledDaemonVersion=$(eval_FromFile "VAR_DAEMON_VERSION" "$VAR_DAEMON_CONFIG_FILE"; echo $VAR_DAEMON_VERSION)
    InstalledDaemonShasum=$(shasum $VAR_DAEMON_CONFIG_FILE | awk '{print $1}')
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' is already installed with version $InstalledDaemonVersion ($InstalledDaemonShasum)..."
    #
    if [[ $ExampleDaemonVersion > $InstalledDaemonVersion ]] || [[ $ExampleDaemonShasum != $InstalledDaemonShasum ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Upgrading Daemon '$VAR_DAEMON_NAME' from version $InstalledDaemonVersion ($InstalledDaemonShasum) to $ExampleDaemonVersion ($ExampleDaemonShasum)..."
    else
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No update for Daemon '$VAR_DAEMON_NAME' available. Nothing to do. Exiting..."
        exit 0
    fi

else
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Daemon '$VAR_DAEMON_NAME' is not installed."
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Installing version $ExampleDaemonVersion ($ExampleDaemonShasum) of daemon '$VAR_DAEMON_NAME'..."
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which cp) -v $VAR_DAEMON_EXAMPLE_FILE $VAR_DAEMON_CONFIG_FILE