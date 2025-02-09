#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/ForEachUtilityScript
####################################################################################################
#VAR_UTILITY=".mitchellvanbijleveld"
#VAR_UTILITY_SCRIPT="ForEachUtilityScript"
VAR_UTILITY_SCRIPT_VERSION="2025.02.03-1153"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo exit PrintMessage shift tr"
VAR_UTILITY_SCRIPT_CONFIGURABLE_SETTINGS=""
####################################################################################################
# UTILITY SCRIPT INFO - .mitchellvanbijleveld/ForEachUtilityScript
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
ForEachUtilityScript(){
    # $1 = FUNCTION TO EXECUTE
    for var_utility_folder in $GLOBAL_VAR_DIR_INSTALLATION/*; do
        unset var_utility_folder_basename
        if [[ -d $var_utility_folder ]]; then
            var_utility_folder_basename=$(basename $var_utility_folder)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Currently checking Utility '$var_utility_folder_basename'..."
        else
            continue
        fi
        #
        for var_utility_script_file in $var_utility_folder/*; do
            unset var_utility_script_file_basename
            if [[ -d $var_utility_script_file ]]; then
                for var_utility_script_file in $var_utility_script_file/*; do
                    if [[ -f $var_utility_script_file ]] && [[ $var_utility_script_file == *".bash" ]]; then
                        var_utility_folder_basename="$(basename $(dirname $(dirname $var_utility_script_file)))/$(basename $(dirname $var_utility_script_file))"
                        var_utility_script_file_basename=$(basename $var_utility_script_file)
                        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Currently checking Utility '$var_utility_folder_basename' Script '$var_utility_script_file_basename'..."
                        #
                        # 
                        #
                        $1 $@
                        #
                        #
                        #
                    else
                        continue
                    fi
                done
            elif [[ -f $var_utility_script_file ]] && [[ $var_utility_script_file == *".bash" ]]; then
                var_utility_folder_basename=$(basename $var_utility_folder)
                var_utility_script_file_basename=$(basename $var_utility_script_file)
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Currently checking Utility '$var_utility_folder_basename' Script '$var_utility_script_file_basename'..."
                #
                # 
                #
                $1 $@
                #
                #
                #
            else
                continue
            fi
        done
    done
}
export -f ForEachUtilityScript
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
if declare -F ForEachUtilityScript > /dev/null; then
    PrintMessage "DEBUG" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Function 'ForEachUtilityScript' is available!"
else
    PrintMessage "FATAL" "$BIN_UTILITY" "$BIN_UTILITY_SCRIPT" "Function 'ForEachUtilityScript' is not available. Exiting..."
    exit 1
fi