#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/CHECKDEPENDENCIES
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="CheckDependencies"
VAR_UTILITY_SCRIPT_VERSION="2024.12.05-2139"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo printf PrintMessage shift tr type"
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/CHECKDEPENDENCIES
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
for var_argument in "$@"; do
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--"*)
            PrintMessage "FATAL" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Invalid option given. Exiting..."
            exit 1
        ;;
        *)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
            VAR_DEPENDENCIES+=($var_argument)
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
if [[ ${#VAR_DEPENDENCIES[@]} -eq 0 ]]; then
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No dependencies forwarded, checking all dependencies..."
    for var_utility_folder in $GLOBAL_VAR_DIR_INSTALLATION/*; do
        if [[ -d $var_utility_folder ]]; then
            var_utility_folder_basename=$(basename $var_utility_folder)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking for Utility Scripts in Utility '$var_utility_folder_basename'..."
        else
            continue
        fi
        #
        for var_utility_script_file in $var_utility_folder/*; do
            if [[ -f $var_utility_script_file ]] && [[ $var_utility_script_file == *".bash" ]]; then
                var_utility_script_file_basename=$(basename $var_utility_script_file)
                PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Getting dependencies for Utility Script '$var_utility_script_file_basename'..."
                #
                for var_dependency in $(eval_FromFile "VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS); do
                    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Adding dependency '$var_dependency' to list of dependencies to check..."
                    VAR_DEPENDENCIES+=($var_dependency)
                done
                #
            else
                continue
            fi
        done
    done
else
    for var_dependency in $@; do
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Adding dependency '$var_dependency' to list of dependencies to check..."
        VAR_DEPENDENCIES+=($var_dependency)
    done
fi
#
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Sorting dependency list and filtering unique dependencies..."
VAR_DEPENDENCIES=($(printf "%s\n" ${VAR_DEPENDENCIES[@]} | sort -f | uniq))
#
for var_dependency in ${VAR_DEPENDENCIES[@]}; do
    PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking dependency '$var_dependency'..."
    if type $var_dependency &> /dev/null; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dependency OK     : $var_dependency"
    else
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dependency NOT OK : $var_dependency"
        VAR_DEPENDENCIES_MISSING+=($var_dependency)
    fi
done
#
if [[ ! ${#VAR_DEPENDENCIES_MISSING[@]} -eq 0 ]]; then
    for var_dependency_missing in ${VAR_DEPENDENCIES_MISSING[@]}; do
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Deoendency '$var_dependency_missing' missing on this system."
    done
    exit 1
fi