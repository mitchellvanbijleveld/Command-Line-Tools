#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - HELLO/WORLD
####################################################################################################
VAR_UTILITY="Hello"
VAR_UTILITY_SCRIPT="World"
VAR_UTILITY_SCRIPT_VERSION="2024.11.26-2241"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="PrintMessage"
####################################################################################################
# UTILITY SCRIPT INFO - HELLO/WORLD
####################################################################################################
####################################################################################################
#
#
#
#
#
PrintMessage
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Hello, World! If you see this message, the Command Line Tools for Linux/macOS are working as expected!"
if [[ $@ == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Try adding some flags (--FLAG) to see if they are recognized!"
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The script is run with the following arguments: '$(echo $@)'"
fi
PrintMessage