#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - HELLO/WORLD
####################################################################################################
VAR_UTILITY="Hello"
VAR_UTILITY_SCRIPT="World"
VAR_UTILITY_SCRIPT_VERSION="2025.06.08-0029"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit PrintMessage shift tr"
UTILITY_SCRIPT_CONFIGURATION_VARS="FirstName LastName"
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
VAR_FIRST_NAME_FILE="$UTILITY_SCRIPT_VAR_DIR_ETC/FirstName"
#
if [[ -z $UTILITY_SCRIPT_VAR_FirstName ]]; then
    UTILITY_SCRIPT_VAR_FirstName="World"
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
                UTILITY_SCRIPT_VAR_FirstName=$2
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
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Hello, $UTILITY_SCRIPT_VAR_FirstName! If you see this message, the Command Line Tools for Linux/macOS are working as expected!"
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
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You changed your name to '$UTILITY_SCRIPT_VAR_FirstName' by using the flag --firstname!"
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You can also change the default first name, so you don't have to always pass the flag!"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Run something like 'mitchellvanbijleveld Configure Global Hello World FirstName HelloWorld'!"
elif [[ $VAR_NAME_CHANGED -eq 1 ]] && [[ -f $VAR_FIRST_NAME_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You changed your name to '$UTILITY_SCRIPT_VAR_FirstName' by using the flag --firstname!"
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Even though you changed the default setting for FirstName to '$(cat $VAR_FIRST_NAME_FILE)',"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You can see that the flag '--firstname' overruled the default setting!"
elif [[ $VAR_NAME_CHANGED -ne 1 ]] && [[ -f $VAR_FIRST_NAME_FILE ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You changed your name to '$UTILITY_SCRIPT_VAR_FirstName' by using a default setting!"
fi
#
PrintMessage