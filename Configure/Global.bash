#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Configure/Global
####################################################################################################
VAR_UTILITY="Configure"
VAR_UTILITY_SCRIPT="Global"
VAR_UTILITY_SCRIPT_VERSION="2025.01.02-2345"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo eval_FromFile exit PrintMessage shift source tr"
####################################################################################################
# UTILITY SCRIPT INFO - Configure/Global
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
VAR_CONFIGURATE_ITEMS=0
VAR_CONFIGURATE_POSSIBLE=1
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
ProcessArguments(){
# $1 = MODE: VALIDATE | CONFIGURE
case $1 in
    "CONFIGURE" | "VALIDATE") VAR_PROCESS_ARGUMENT_MODE=$1;;
esac

for var_argument in "$@"; do
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
        ;;
        *)       
            if [[ $VAR_VAR_UTILITY == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as VAR_VAR_UTILITY..."
                VAR_VAR_UTILITY=$var_argument_CAPS
            elif [[ $VAR_VAR_UTILITY_SCRIPT == "" ]] && [[ $var_argument_CAPS != "--"* ]]; then
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Setting '$var_argument' as VAR_VAR_UTILITY_SCRIPT..."
                VAR_VAR_UTILITY_SCRIPT=$var_argument_CAPS
            else
                for var_configurable_setting in $VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS; do
                    var_configurable_setting_CAPS=$(echo $var_configurable_setting | tr '[:lower:]' '[:upper:]')
                    if [[ $var_configurable_setting_CAPS == $var_argument_CAPS ]]; then
                        case $VAR_PROCESS_ARGUMENT_MODE in
                            "CONFIGURE")
                                if [[ -f "$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting" ]]; then
                                    if [[ $2 == $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting") ]]; then
                                        PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Skipping Configuring '$var_configurable_setting' with value '$2' because it has already been configured with this value..."  
                                    else
                                        PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Configuring '$var_configurable_setting' with value '$2' from '$(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting")' to '$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting'..."                   
                                    fi
                                else
                                    PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Configuring '$var_configurable_setting' with value '$2' to '$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting'..."
                                fi
                                echo "$2" > "$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting"
                            ;;
                            "VALIDATE")
                                if [[ $2 == "" ]]; then
                                    PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Configuration parameter '$var_configurable_setting' needs a value..."
                                    VAR_CONFIGURATE_POSSIBLE=0
                                fi
                                ((VAR_CONFIGURATE_ITEMS++))
                            ;;
                        esac
                    fi
                done
            fi
        ;;
    esac
    #
    shift
done
}
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
# CHECK CONFIGURABLE SETTINGS
####################################################################################################
source "$GLOBAL_VAR_DIR_INSTALLATION/Configure/Configure.bash" "$@" "--SKIP-START-SCRIPT" 
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Fetching configurable settings from utility script..."
eval_FromFile "VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS" $VAR_UTILITY_SCRIPT_FILE_PATH
#
if [[ $VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS == "" ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Nothing to configure for $VAR_VAR_UTILITY/$VAR_VAR_UTILITY_SCRIPT..."
    exit 0
fi
#
PrintMessage "DEBUG " "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking if all configurable items are set correctly..."
ProcessArguments "VALIDATE" "$@"
PrintMessage
#
if [[ $VAR_CONFIGURATE_ITEMS -eq 0 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No configurable arguments passed."
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The following parameters are available:"
    for var_configurable_setting in $VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS; do
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $var_configurable_setting"
    done
elif [[ $VAR_CONFIGURATE_POSSIBLE -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting to configure $VAR_VAR_UTILITY/$VAR_VAR_UTILITY_SCRIPT..."
    ProcessArguments "CONFIGURE" "$@"
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "OK"
else
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Configuration is not possible!"  
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Please check the 'WARNING' messages above this line."
fi
PrintMessage