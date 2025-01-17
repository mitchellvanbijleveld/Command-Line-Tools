#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - MITCHELLVANBIJLEVELD/CHECKDEPENDENCIES
####################################################################################################
VAR_UTILITY="bin"
VAR_UTILITY_SCRIPT="CheckDependencies"
VAR_UTILITY_SCRIPT_VERSION="2024.12.22-2159"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="echo printf PrintMessageV2 shift tr type"
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
    PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Processing argument '$var_argument'..."
    var_argument_CAPS=$(echo $var_argument | tr '[:lower:]' '[:upper:]')
    #
    case $var_argument_CAPS in
        "--RUN-IN-BACKGROUND")
            RUN_IN_BACKGROUND=1
        ;;
        "--"*)
            die_ProcessArguments_InvalidFlag $var_argument
        ;;
        *)
            PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Ignoring argument '$var_argument'..."
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
FetchAllDependencies(){
    for var_dependency in $(eval_FromFile "VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS" $var_utility_script_file; echo $VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS); do
        VAR_DEPENDENCIES+=($var_dependency)
    done
}
#
FindNonWorkingUtilityScript(){
    for var_dependency_missing in ${VAR_DEPENDENCIES_MISSING[@]}; do
        if [[ $(eval_FromFile "VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS" "$var_utility_script_file"; echo "$VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS") == *"$var_dependency_missing"* ]]; then
            VAR_NON_WORKING_UTILITY_SCRIPTS+=("$var_utility_folder_basename/$var_utility_script_file_basename")
            break
        fi
    done
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
if [[ ${#VAR_DEPENDENCIES[@]} -eq 0 ]]; then
    PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No dependencies passed with arguments..."
    PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Checking dependencies for all Utility Scripts..."
    #
    ForEachUtilityScript FetchAllDependencies 
else
    PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dependencies passed with arguments..."
    PrintMessageV2 "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Adding dependencies passed with arguments to the list of dependencies to check..."
    #
    for var_dependency in $@; do
        VAR_DEPENDENCIES+=($var_dependency)
    done
fi
#
VAR_DEPENDENCIES=($(printf "%s\n" ${VAR_DEPENDENCIES[@]} | sort -f | uniq))
#
for var_dependency in ${VAR_DEPENDENCIES[@]}; do
    if ! type $var_dependency &> /dev/null; then
        VAR_DEPENDENCIES_MISSING+=($var_dependency)
    fi
done
#
for var_dependency_missing in ${VAR_DEPENDENCIES_MISSING[@]}; do
    PrintMessageV2 "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Dependency '$var_dependency_missing' missing on this system."
done
#
if [[ $RUN_IN_BACKGROUND -eq 1 ]] && [[ ${#VAR_DEPENDENCIES_MISSING[@]} -eq 0 ]]; then
    exit 0
elif [[ $RUN_IN_BACKGROUND -eq 1 ]] && [[ ${#VAR_DEPENDENCIES_MISSING[@]} -ne 0 ]]; then
    PrintMessageV2
    exit 1
elif [[ $RUN_IN_BACKGROUND -eq 0 ]] && [[ ${#VAR_DEPENDENCIES_MISSING[@]} -eq 0 ]]; then
    PrintMessageV2 "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "All dependencies are available. All Utility Scripts should work."
    exit 0
elif [[ $RUN_IN_BACKGROUND -eq 0 ]] && [[ ${#VAR_DEPENDENCIES_MISSING[@]} -ne 0 ]]; then
    PrintMessageV2
fi
#
#
#
ForEachUtilityScript FindNonWorkingUtilityScript
#
VAR_NON_WORKING_UTILITY_SCRIPTS=($(printf "%s\n" ${VAR_NON_WORKING_UTILITY_SCRIPTS[@]} | sort -f | uniq))
#
for var_non_working_utility_script in ${VAR_NON_WORKING_UTILITY_SCRIPTS[@]}; do
    var_missing_dependencies=""
    for var_dependency_missing in ${VAR_DEPENDENCIES_MISSING[@]}; do
        if [[ $(eval_FromFile "VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS" "$GLOBAL_VAR_DIR_INSTALLATION/$var_non_working_utility_script"; echo "$VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS") == *"$var_dependency_missing"* ]]; then
            var_missing_dependencies="$var_missing_dependencies '$var_dependency_missing'"
        fi
    done
    PrintMessageV2 "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Utility Script '${var_non_working_utility_script%.bash}' will not work because of missing dependencies: $(echo $var_missing_dependencies)"
done