#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/PrintMessage
####################################################################################################
#VAR_UTILITY=".mitchellvanbijleveld"
#VAR_UTILITY_SCRIPT="PrintMessage"
VAR_UTILITY_SCRIPT_VERSION="2025.03.24-0044"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="date echo eval mkdir printf shift touch"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/PrintMessage
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
if [[ -z $PRINTMESSAGE_LOG_DIRECTORY ]]; then
    PRINTMESSAGE_LOG_DIRECTORY="$(realpath ~)/.mitchellvanbijleveld/Command-Line-Tools/var/log"
    # echo $PRINTMESSAGE_LOG_DIRECTORY
    mkdir -p $PRINTMESSAGE_LOG_DIRECTORY
fi
#
if [[ -z $PRINTMESSAGE_LOG_FILE ]]; then
    export PRINTMESSAGE_LOG_FILE="$PRINTMESSAGE_LOG_DIRECTORY/mitchellvanbijleveld.$(date +'%Y%m%d-%H%M%S').log"
    echo "PrintMessage Log File: '$PRINTMESSAGE_LOG_FILE'..."
    touch $PRINTMESSAGE_LOG_FILE
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
BIN_PrintLogLine_TimeStamp(){
    echo $(date +'%Y-%m-%d %H:%M:%S')
}
export -f BIN_PrintLogLine_TimeStamp
#
BIN_PrintLogLine_UtilityAndUtilityScript(){
    # $1 = UTILITY | COMMAND
    # $2 = UTILITY SCRIPT | COMMAND
    if [[ $1 == "COMMAND" ]]; then
        echo "$(printf '%-34s' $(echo "$1=$2"))"
    else
        echo "$(printf '%-34s' $(echo "$1/$2"))"
    fi
}
export -f BIN_PrintLogLine_UtilityAndUtilityScript
#
BIN_PrintLogLine_LogLevel(){
    # $1 = LOG LEVEL
    echo "[ $(printf '%-8s' "$1") ]"
}
export -f BIN_PrintLogLine_LogLevel
#
BIN_PrintMessage_UnsetVariables() {
    unset PrintMessage_LogLevel
    unset PrintMessage_Utility
    unset PrintMessage_UtilityScript
    unset PrintMessage_Text
    unset PrintMessage_Command
}
#
eval_PrintMessage_Internal_UnsetVariables=$(declare -f BIN_PrintMessage_UnsetVariables | sed '
    1s/BIN_PrintMessage_UnsetVariables/BIN_PrintMessage_Internal_UnsetVariables/;
    s/PrintMessage_LogLevel/PrintMessage_Internal_LogLevel/g;
    s/PrintMessage_Utility/PrintMessage_Internal_Utility/g;
    s/PrintMessage_UtilityScript/PrintMessage_Internal_UtilityScript/g;
    s/PrintMessage_Text/PrintMessage_Internal_Text/g;
    s/PrintMessage_Command/PrintMessage_Internal_Command/g'); eval "$eval_PrintMessage_Internal_UnsetVariables"
#
export -f BIN_PrintMessage_UnsetVariables
export -f BIN_PrintMessage_Internal_UnsetVariables
#
PrintMessage() {
    #
    if [[ -z $@ ]]; then
        [[ $GLOBAL_VAR_DEBUG ]] || echo
        BIN_PrintMessage_UnsetVariables; return 0
    fi
    #
    #
    #
    for PrintMessage_Part in "$@"; do
        if [[ -z $PrintMessage_LogLevel ]]; then
            PrintMessage_LogLevel=$PrintMessage_Part; shift
        elif [[ -z $PrintMessage_Utility ]]; then
            PrintMessage_Utility=$PrintMessage_Part; shift
        elif [[ -z $PrintMessage_UtilityScript ]]; then
            PrintMessage_UtilityScript=$PrintMessage_Part; shift
        elif [[ -z $PrintMessage_Text ]] && [[ -z $PrintMessage_Command ]]; then
            if [[ $PrintMessage_Utility == 'COMMAND' ]]; then
                PrintMessage_Text="$@"
            else
                if [[ $PrintMessage_Part == $(which $PrintMessage_Part) ]]; then
                    PrintMessage_Command=$PrintMessage_Part; shift
                fi
                #
                PrintMessage_Text="$@"
            fi
            #
            if [[ -z $PrintMessage_Text ]]; then
                PrintMessage_Text=' '
            fi
        fi
    done
    #
    #
    #
    if [[ -z $PrintMessage_LogLevel ]] || [[ -z $PrintMessage_Utility ]] || [[ -z $PrintMessage_UtilityScript ]] || [[ -z $PrintMessage_Text ]]; then
        echo "!!!!! INVALID PRINTMESSAGE: ONE OF THE VALUES IS EMPTY !!!!!"
        BIN_PrintMessage_UnsetVariables; return 0
    fi
    #
    #
    #
    if [[ $PrintMessage_Command ]]; then
        #
        if [[ $GLOBAL_VAR_DRY_RUN ]]; then
            BIN_PrintMessage_Internal "DRY RUN" "$PrintMessage_Utility" "$PrintMessage_UtilityScript" "$PrintMessage_Command $PrintMessage_Text"
        else
            BIN_PrintMessage_Internal "COMMAND" "$PrintMessage_Utility" "$PrintMessage_UtilityScript" "$PrintMessage_Command $PrintMessage_Text"
            #
            PRINTMESSAGE_TMP_FILE_EXIT_CODE=$(mktemp)
            BIN_PrintMessage_Internal "DEBUG" ".mitchellvanbijleveld" "PrintMessage" "Command Exit Code File: '$PRINTMESSAGE_TMP_FILE_EXIT_CODE'..."
            #
            {
                eval $PrintMessage_Command $PrintMessage_Text 2>&1
                echo $? > "$PRINTMESSAGE_TMP_FILE_EXIT_CODE"
            } | while IFS= read -r PrintMessage_Command_Result; do
                BIN_PrintMessage_Internal "$PrintMessage_LogLevel" "COMMAND" "$PrintMessage_Command" "$PrintMessage_Command_Result"
            done
            #
        fi
        #
        BIN_PrintMessage_UnsetVariables; return 0
        #
    fi
    #
    #
    echo "$(BIN_PrintLogLine_TimeStamp)" "$(BIN_PrintLogLine_UtilityAndUtilityScript "$PrintMessage_Utility" "$PrintMessage_UtilityScript")" "$(BIN_PrintLogLine_LogLevel "$PrintMessage_LogLevel")" "$PrintMessage_Text" >> $PRINTMESSAGE_LOG_FILE
    #
    #
    if [[ $GLOBAL_VAR_DEBUG ]]; then
        case $PrintMessage_LogLevel in
            'COMMAND' | 'CONFIG' | 'CONFIGURE' | 'DEBUG' | 'DRY RUN' | 'FATAL' | 'INFO' | 'VERBOSE' | 'WARNING')
                echo "$(BIN_PrintLogLine_TimeStamp)" "$(BIN_PrintLogLine_UtilityAndUtilityScript "$PrintMessage_Utility" "$PrintMessage_UtilityScript")" "$(BIN_PrintLogLine_LogLevel "$PrintMessage_LogLevel")" "$PrintMessage_Text"
            ;;
            *) echo "$(BIN_PrintLogLine_TimeStamp)" "$(BIN_PrintLogLine_UtilityAndUtilityScript "$PrintMessage_Utility" "$PrintMessage_UtilityScript")" "$(BIN_PrintLogLine_LogLevel "$PrintMessage_LogLevel")" "!!!!! INVALID PRINTMESSAGE: LOG LEVEL '$PrintMessage_LogLevel' IS NOT SUPPORTED !!!!!";;
        esac
    else
        case $PrintMessage_LogLevel in
            'COMMAND' | 'CONFIG' | 'DEBUG') BIN_PrintMessage_UnsetVariables; return 0;;
            'DRY RUN' | 'FATAL' | 'WARNING') echo "$(BIN_PrintLogLine_LogLevel "$PrintMessage_LogLevel")" "$PrintMessage_Text";;
            'CONFIGURE' | 'INFO') echo "$PrintMessage_Text";;
            'VERBOSE') 
            if [[ $GLOBAL_VAR_VERBOSE ]]; then
                if [[ $PrintMessage_Utility == "COMMAND" ]]; then
                    echo "$(BIN_PrintLogLine_LogLevel "$PrintMessage_LogLevel")" "$(echo $(BIN_PrintLogLine_UtilityAndUtilityScript "$PrintMessage_Utility" "$PrintMessage_UtilityScript")):" "$PrintMessage_Text"
                else
                    echo "$(BIN_PrintLogLine_LogLevel "$PrintMessage_LogLevel")" "$PrintMessage_Text"
                fi
            fi
            ;;
            *) echo "!!!!! INVALID PRINTMESSAGE: LOG LEVEL '$PrintMessage_LogLevel' IS NOT SUPPORTED !!!!!";;
        esac
    fi
    #
    #
    #
    BIN_PrintMessage_UnsetVariables; return 0
}
#
eval_PrintMessage_Internal=$(declare -f PrintMessage | sed '
    1s/PrintMessage/BIN_PrintMessage_Internal/;
    s/BIN_PrintMessage_UnsetVariables/BIN_PrintMessage_Internal_UnsetVariables/g;
    s/PrintMessage_LogLevel/PrintMessage_Internal_LogLevel/g;
    s/PrintMessage_Utility/PrintMessage_Internal_Utility/g;
    s/PrintMessage_UtilityScript/PrintMessage_Internal_UtilityScript/g;
    s/PrintMessage_Text/PrintMessage_Internal_Text/g;
    s/PrintMessage_Command/PrintMessage_Internal_Command/g'); eval "$eval_PrintMessage_Internal"
export -f PrintMessage
export -f BIN_PrintMessage_Internal
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
if declare -F PrintMessage > /dev/null; then
    PrintMessage "DEBUG" ".mitchellvanbijleveld" "PrintMessage" "Function 'PrintMessage' is available!"
else
    PrintMessage "FATAL" ".mitchellvanbijleveld" "PrintMessage" "Function 'PrintMessage' is not available. Exiting..."
    exit 1
fi
#
if declare -F BIN_PrintMessage_Internal > /dev/null; then
    PrintMessage "DEBUG" ".mitchellvanbijleveld" "PrintMessage" "Function 'BIN_PrintMessage_Internal' is available!"
else
    PrintMessage "FATAL" ".mitchellvanbijleveld" "PrintMessage" "Function 'BIN_PrintMessage_Internal' is not available. Exiting..."
    exit 1
fi