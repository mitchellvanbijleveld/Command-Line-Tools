#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/die_ProcessArguments_InvalidFlag
####################################################################################################
#VAR_UTILITY=".mitchellvanbijleveld"
#VAR_UTILITY_SCRIPT="die_ProcessArguments_InvalidFlag"
VAR_UTILITY_SCRIPT_VERSION="2025.02.09-2120"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="exit PrintMessage"
UTILITY_SCRIPT_CONFIGURATION_VARS=""
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/die_ProcessArguments_InvalidFlag
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
#
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
die_ProcessArguments_InvalidFlag(){
    # $1 = FLAG
    PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The provided flag ($1) is not supported. Exiting..."
    PrintMessage
    exit 1
}
export -f die_ProcessArguments_InvalidFlag
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
if declare -F die_ProcessArguments_InvalidFlag > /dev/null; then
    PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Function 'die_ProcessArguments_InvalidFlag' is available!"
else
    PrintMessage "FATAL" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Function 'die_ProcessArguments_InvalidFlag' is not available. Exiting..."
    exit 1
fi