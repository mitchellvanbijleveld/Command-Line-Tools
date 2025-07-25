#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Configure/Configure
####################################################################################################
VAR_UTILITY="Configure"
VAR_UTILITY_SCRIPT="Configure"
VAR_UTILITY_SCRIPT_VERSION="2025.06.07-2237"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo eval_FromFile exit mkdir PrintMessage shift source tr unset"
UTILITY_SCRIPT_CONFIGURATION_VARS=""
####################################################################################################
# UTILITY SCRIPT INFO - Configure/Configure
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
VAR_UTILITY_FOLDER_PATH=$GLOBAL_VAR_DIR_INSTALLATION
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
        "--LIST-CONFIG" | "--PRINT-CONFIG" | "--SHOW-CONFIG")
            PRINT_CONFIG=1
        ;;
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
        ;;
        *)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
        ;;
    esac
    #
    # shift
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
CreateConfigurationDirectory(){
    if [[ ! -d $UTILITY_SCRIPT_VAR_DIR_ETC ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Creating configuration directory '$UTILITY_SCRIPT_VAR_DIR_ETC'..."
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which mkdir) -p $UTILITY_SCRIPT_VAR_DIR_ETC
    fi
    #
    if [[ -d $UTILITY_SCRIPT_VAR_DIR_ETC ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Configuration Directory '$UTILITY_SCRIPT_VAR_DIR_ETC' exists..."
        return 0
    else
        return 1
    fi
}
#
SetConfigurationParameter(){
    # $1 = Configuration Parameter Name
    # $2 = Configuration Parameter Value
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Configure Parameter File Path is '$UTILITY_SCRIPT_VAR_DIR_ETC/$1'..."
    #
    if [[ ! -f "$UTILITY_SCRIPT_VAR_DIR_ETC/$1" ]]; then
        PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Configure Parameter '$1' with value '$2'..."
    elif [[ $2 == $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/$1") ]]; then
        PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Skip Configure Parameter '$1' because value is already set to '$2'..."
        return 0
    else
        PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Configure Parameter '$1' with value '$2' from current value '$(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/$1")'..."                                           
    fi
    #
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which echo) "'$2' > '$UTILITY_SCRIPT_VAR_DIR_ETC/$1'"           
    #
    if [[ -f "$UTILITY_SCRIPT_VAR_DIR_ETC/$1" && $2 == $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/$1") ]]; then
        return 0
    else
        PrintMessage "WARNING" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "There was a problem configuring '$1' with value '$2'..."   
        return 1
    fi
}
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
if [[ $1 == "mitchellvanbijleveld" ]]; then
    VAR_UTILITY_SCRIPT_FILE_PATH="$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld"
    UTILITY_SCRIPT_VAR_DIR_ETC="$GLOBAL_VAR_DIR_ETC"
    shift
else
    source "$GLOBAL_VAR_DIR_INSTALLATION/.mitchellvanbijleveld/Find/UtilityScriptFilePath.bash"
    UTILITY_SCRIPT_VAR_DIR_ETC="$GLOBAL_VAR_DIR_ETC/$VAR_UTILITY/$VAR_UTILITY_SCRIPT"
    VAR_CONFIGURE_UTILITY=$VAR_UTILITY
    VAR_CONFIGURE_UTILITY_SCRIPT=$VAR_UTILITY_SCRIPT
    VAR_UTILITY="Configure"
    VAR_UTILITY_SCRIPT="Configure"
fi
#
if [[ -z $VAR_UTILITY_SCRIPT_FILE_PATH ]]; then
    exit 1
fi
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Fetching configurable settings from utility script..."
eval_FromFile "UTILITY_SCRIPT_CONFIGURATION_VARS" $VAR_UTILITY_SCRIPT_FILE_PATH
#
if [[ -z $UTILITY_SCRIPT_CONFIGURATION_VARS ]]; then
    eval_FromFile "VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS" $VAR_UTILITY_SCRIPT_FILE_PATH

    if [[ -z $VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No parameters to configure for $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT..."
        exit 0
    else
        UTILITY_SCRIPT_CONFIGURATION_VARS="$VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS"
    fi
else
    if ! CreateConfigurationDirectory; then
        PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Configuration Directory for $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT could not be created..."
        exit 1
    fi
fi
#
if [[ -z $@ ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No parameters passed as arguments."
    PrintMessage
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The following parameters are available to configure for $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT:"
    for var_configurable_setting in $UTILITY_SCRIPT_CONFIGURATION_VARS; do
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $var_configurable_setting"
    done
    exit 1
fi
#
if [[ $PRINT_CONFIG -eq 1 ]]; then
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Printing Configuration for $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT:"
    # Generate spaces, based on longest string.
    for var_configurable_setting in $UTILITY_SCRIPT_CONFIGURATION_VARS; do
        if [[ ${#var_configurable_setting} -gt $length ]]; then
            length=${#var_configurable_setting}
        fi
    done
    #
    for var_configurable_setting in $UTILITY_SCRIPT_CONFIGURATION_VARS; do
        if [[ -f "$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting" ]]; then
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $(printf "%-${length}s %s\n" $var_configurable_setting): $(cat "$UTILITY_SCRIPT_VAR_DIR_ETC/$var_configurable_setting")"
        else
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $(printf "%-${length}s %s\n" $var_configurable_setting): N/A (No Configuration File)"
        fi
    done
    #
    exit 0
fi
#
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Start Configuring $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT..."
#
until [[ $# -eq 0 ]]; do
    unset CONFIGURED; CAPS_1=$(echo $1 | tr '[:lower:]' '[:upper:]')
   #
    for var_configurable_setting in $UTILITY_SCRIPT_CONFIGURATION_VARS; do
        var_configurable_setting_CAPS=$(echo $var_configurable_setting | tr '[:lower:]' '[:upper:]')
        #
        if [[ $var_configurable_setting_CAPS == $CAPS_1 ]]; then
            if [[ -z $2 ]]; then
                PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Skip Configure Parameter '$1' because no value was given..."
            else
                SetConfigurationParameter "$var_configurable_setting" "$2"
            fi
            #
            CONFIGURED=1; break
        fi
    done
    #
    if [[ -z $CONFIGURED ]]; then
        if [[ -z $2 ]]; then
           PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Skip Configure Parameter '$1' because it is not valid for $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT and no value was given..."
        else
            PrintMessage "CONFIGURE" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Skip Configure Parameter '$1' with value '$2' because it is not valid for $VAR_CONFIGURE_UTILITY/$VAR_CONFIGURE_UTILITY_SCRIPT..."
        fi
    fi
    #
    shift; shift # Use shift twice because 'shift 2' does not work if it is the last argument
    #
done