#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - BIN/CHECKDEPENDENCIES
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="CheckDependencies"
VAR_UTILITY_SCRIPT_VERSION="2024.12.05-2139"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="PrintMessage type"
####################################################################################################
# UTILITY SCRIPT INFO - BIN/CHECKDEPENDENCIES
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
VAR_DEPENDENCIES=$@
VAR_DEPENDENCIES_MISSING=""
####################################################################################################
# VARIABLES
####################################################################################################
####################################################################################################
#
#
#
#
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking deoendencies '$VAR_DEPENDENCIES'..."
#
for var_dependency in $VAR_DEPENDENCIES; do
    if type $var_dependency &> /dev/null; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dependency OK     : $var_dependency"
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dependency NOT OK : $var_dependency"
        VAR_DEPENDENCIES_MISSING="$VAR_DEPENDENCIES_MISSING $var_dependency"
    fi
done
#
if [[ $VAR_DEPENDENCIES_MISSING != "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Deoendencies '$(echo $VAR_DEPENDENCIES_MISSING)' missing on this system."
    exit 1
fi