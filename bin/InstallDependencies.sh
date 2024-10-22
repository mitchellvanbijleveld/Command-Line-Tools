#!/bin/bash

VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="InstallDependencies"
VAR_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo"

if [[ "$@" == *"--auto-install"* ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Automatic Installation is enabled!"
fi

PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking for dependencies..."
"$(which bash)" "$VAR_BIN_INSTALL_DIR/bin/CheckDependencies.sh" "--install-check"
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Reading missing dependencies from file '.mvb.missing_dependencies'..."

if ! [[ -e ".mvb.missing_dependencies" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "File with missing dependencies does not exist. Assuming there are no missing dependencies. Nothing to do..."
    exit 0
fi

VAR_MISSING_DEPENDENCIES=$(cat ".mvb.missing_dependencies")
"$(which rm)" ".mvb.missing_dependencies"

if [[ $VAR_MISSING_DEPENDENCIES == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No missing dependencies. Nothing to do..."
    exit 0
fi

PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Missing dependencies: $VAR_MISSING_DEPENDENCIES"

for var_missing_dependency in $VAR_MISSING_DEPENDENCIES; do
    echo "installing dep '$var_missing_dependency'..."
done