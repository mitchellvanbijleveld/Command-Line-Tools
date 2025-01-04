#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - HELLO/WORLD
####################################################################################################
VAR_UTILITY="Hello"
VAR_UTILITY_SCRIPT="World"
VAR_UTILITY_SCRIPT_VERSION="2024.12.23-0247"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit PrintMessage shift tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS="FirstName LastName"
####################################################################################################
# UTILITY SCRIPT INFO - HELLO/WORLD
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
VAR_FIRST_NAME_FILE="$VAR_UTILITY_SCRIPT_DIR_ETC/FirstName"
if [[ -f $VAR_FIRST_NAME_FILE ]]; then
    VAR_FIRST_NAME=$(cat $VAR_FIRST_NAME_FILE)
else
    VAR_FIRST_NAME="World"
fi
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
        "--FIRSTNAME")
            if [[ $2 == "" ]]; then
                PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The flag --firstname should have a value. Exiting..."
                exit 1
            else
                VAR_FIRST_NAME=$2
                VAR_NAME_CHANGED=1
            fi
        ;;
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
PrintMessage
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Hello, $VAR_FIRST_NAME! If you see this message, the Command Line Tools for Linux/macOS are working as expected!"
#
PrintMessage
#
if [[ $VAR_NAME_CHANGED -ne 1 ]] && [[ ! -f $VAR_FIRST_NAME_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Try adding the flag --firstname followed by your first name to customize your greeting!"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Run something like 'mitchellvanbijleveld hello world --firstname HelloWorld'!"
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You can also change the default first name, so you don't have to always pass the flag!"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Run something like 'mitchellvanbijleveld Configure Global Hello World FirstName HelloWorld'!"
elif [[ $VAR_NAME_CHANGED -eq 1 ]] && [[ ! -f $VAR_FIRST_NAME_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You changed your name to '$VAR_FIRST_NAME' by using the flag --firstname!"
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You can also change the default first name, so you don't have to always pass the flag!"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Run something like 'mitchellvanbijleveld Configure Global Hello World FirstName HelloWorld'!"
elif [[ $VAR_NAME_CHANGED -eq 1 ]] && [[ -f $VAR_FIRST_NAME_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You changed your name to '$VAR_FIRST_NAME' by using the flag --firstname!"
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Even though you changed the default setting for FirstName to '$(cat $VAR_FIRST_NAME_FILE)',"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You can see that the flag '--firstname' overruled the default setting!"
elif [[ $VAR_NAME_CHANGED -ne 1 ]] && [[ -f $VAR_FIRST_NAME_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You changed your name to '$VAR_FIRST_NAME' by using a default setting!"
fi
#
PrintMessage