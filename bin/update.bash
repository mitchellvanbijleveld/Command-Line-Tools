#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/UPDATE
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="update"
VAR_UTILITY_SCRIPT_VERSION="2024.12.13-0109"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="cat git PrintMessage"
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/UPDATE
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
VAR_VERSION_FILE="$GLOBAL_VAR_DIR_INSTALLATION/VERSION"
#
VAR_OLD_VERSION=$(cat $VAR_VERSION_FILE)
####################################################################################################
# VARIABLES
####################################################################################################
####################################################################################################
#
#
#
#
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Using command 'git' to pull the latest version..."
if [[ $GLOBAL_VAR_DEBUG -eq 0 ]]; then
    PrintMessage "INFO" $(which git) -C $GLOBAL_VAR_DIR_INSTALLATION pull >/dev/null
elif [[ $GLOBAL_VAR_DEBUG -eq 1 ]]; then
    PrintMessage "DEBUG" $(which git) -C $GLOBAL_VAR_DIR_INSTALLATION pull
fi
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Reading new version from VERSION..."
VAR_NEW_VERSION=$(cat $VAR_VERSION_FILE)
#
if [[ $VAR_NEW_VERSION > $VAR_OLD_VERSION ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools has been updated from version $VAR_OLD_VERSION to $VAR_NEW_VERSION!"
elif [[ $VAR_NEW_VERSION < $VAR_OLD_VERSION ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools has been downgraded from version $VAR_OLD_VERSION to $VAR_NEW_VERSION!"
elif [[ $VAR_NEW_VERSION = $VAR_OLD_VERSION ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Command Line Tools has is already up to date ($VAR_OLD_VERSION)!"
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Something is weird while comparing versions."
fi