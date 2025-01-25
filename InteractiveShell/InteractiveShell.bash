#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - InteractiveShell/InteractiveShell
####################################################################################################
VAR_UTILITY="InteractiveShell"
VAR_UTILITY_SCRIPT="InteractiveShell"
VAR_UTILITY_SCRIPT_VERSION="2025.01.04-0313"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="basename clear echo exit printf PrintMessage shift tr"
####################################################################################################
# UTILITY SCRIPT INFO - InteractiveShell/InteractiveShell
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
VAR____VERSION=$VAR_UTILITY_SCRIPT_VERSION
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
##################################################
##################################################
# Print Utilities & Utility Scripts
##################################################
PrintAvailableUtilities(){
    AvailableUtilities=()
    #
    for var_utility_folder in "$GLOBAL_VAR_DIR_INSTALLATION"/*; do
        if [[ -d  $var_utility_folder ]]; then
            AvailableUtilities+=($var_utility_folder)
            var_var_utility_folder_basename=$(basename $var_utility_folder)
            #
            if [[ $GLOBAL_VAR_DEBUG -eq 1 ]]; then
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  [$(printf '%2d\n' ${#AvailableUtilities[@]})] $var_var_utility_folder_basename ($var_utility_folder)"
            else
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  [$(printf '%2d\n' ${#AvailableUtilities[@]})] $var_var_utility_folder_basename"
            fi
        fi
    done
    #
    if [[ ${#AvailableUtilities[@]} -eq 0 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No Utilities available."
    fi
}
#
PrintAvailableUtilityScripts(){
    # $1 = Utility
    AvailableUtilityScripts=()
    #
    for var_utility_script_file in "$GLOBAL_VAR_DIR_INSTALLATION/$1/"*; do
        if [[ -f $var_utility_script_file ]] && [[ $var_utility_script_file == *".bash" ]] && [[ $(shasum $var_utility_script_file | awk '{print $1}') != 'da39a3ee5e6b4b0d3255bfef95601890afd80709' ]]; then
            AvailableUtilityScripts+=($var_utility_script_file)  
            var_var_utility_script_file_basename=$(basename $var_utility_script_file)
            #
            if [[ $GLOBAL_VAR_DEBUG -eq 1 ]]; then
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  [$(printf '%2d\n' ${#AvailableUtilityScripts[@]})] $(echo $var_var_utility_script_file_basename | sed 's/.bash$//') ($var_utility_script_file)"
            else
                PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  [$(printf '%2d\n' ${#AvailableUtilityScripts[@]})] $(echo $var_var_utility_script_file_basename | sed 's/.bash$//')"
            fi
        fi
    done
    #
    if [[ ${#AvailableUtilityScripts[@]} -eq 0 ]]; then
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "No Utility Scripts available."
    fi
}
##################################################
# Print Utilities & Utility Scripts
##################################################
##################################################
#
#
#
##################################################
##################################################
# Print Menu
##################################################
PrintMenu_Header(){
    VAR__MENU=$1
    #
    $(which clear)
    #
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "###########################################################################"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "#                                                 Version $VAR____VERSION #"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "#                                                                         #"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "# Interactive Shell - Command Line Tools                                  #"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "#                                                                         #"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "# $(printf '%-32s\n' "$VAR__MENU")          © 2025 Mitchell van Bijleveld #"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "###########################################################################"
}
#
PrintMenu_Footer(){
    echo "                                                                           "
}
#
PrintMenu_InteractiveShell(){
    PrintMenu_Header
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Welcome to the Interactive Shell for Linux Command Line Tools!"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "This menu helps you navigating through all available utilities. After"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "selecting the Utility, you will be able to start a Utility Script."
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The following utilities are available:"
    PrintAvailableUtilities    
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Available Actions:"; ClearUserActions
    PrintUserAction "1-${#AvailableUtilities[@]}" "Utility from the list above"
    PrintUserAction "Q" "Quit Interactive Shell"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    AskForUserAction
    #
    if [[ $UserInput -ge 1 ]] && [[ $UserInput -le ${#AvailableUtilities[@]} ]]; then
        VAR_VAR_UTILITY=$(basename ${AvailableUtilities[$((UserInput - 1))]})
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You selected a number! The number is $UserInput"
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The Utility that belongs here here is $VAR_VAR_UTILITY"
        PrintMenu_Utility $VAR_VAR_UTILITY
    else
        case $(echo $UserInput | tr '[:lower:]' '[:upper:]') in
            "Q") PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Quiting Interactive Shell..."; PrintMessage; exit 0;;
            *) PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Can't handle this option."; PrintMessage; exit 1;;
        esac
    fi
}
#
PrintMenu_Utility(){
    # $1 = Utility
    PrintMenu_Header "Utility Menu"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "This is the Utility menu for $1."
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The following Utility Scripts are available:"
    PrintAvailableUtilityScripts $1
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Available Actions:"; ClearUserActions
    PrintUserAction "1-${#AvailableUtilityScripts[@]}" "Utility Script from the list above"
    PrintUserAction "B" "Back"
    PrintUserAction "Q" "Quit Interactive Shell"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    AskForUserAction
    #
    if [[ $UserInput -ge 1 ]] && [[ $UserInput -le ${#AvailableUtilityScripts[@]} ]]; then
        VAR_VAR_UTILITY_SCRIPT=$(basename ${AvailableUtilityScripts[$((UserInput - 1))]} | sed 's/.bash$//')
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "You selected a number! The number is $UserInput"
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "The Utility script belong here is $VAR_VAR_UTILITY_SCRIPT"
        PrintMenu_UtilityScript $1 $VAR_VAR_UTILITY_SCRIPT
    else
        case $(echo $UserInput | tr '[:lower:]' '[:upper:]') in
            "B") PrintMenu_InteractiveShell;;
            "Q") PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Quiting Interactive Shell..."; PrintMessage; exit 0;;
            *) PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Can't handle this option."; PrintMessage; exit 1;;
        esac
    fi
}
#
PrintMenu_UtilityScript(){
    # $1 = Utility
    # $2 = Utility Script

    PrintMenu_Header "Utility Script Menu"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "                                                                           "
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Starting Utility Script $1/$2..."
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "###########################################################################"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" $(which bash) "$GLOBAL_VAR_DIR_INSTALLATION/mitchellvanbijleveld '$1' '$2' '--START-FROM-INTERACTIVE-SHELL'"
    exit 0

}
##################################################
# Print Menu
##################################################
##################################################
#
#
#
##################################################
# User Actions
##################################################
##################################################
ClearUserActions(){
    unset AvailableChoicesString
}
#
PrintUserAction(){
    # $1 = Option Key
    # $2 = Option Description

    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - $(printf '%-4s' "$1") : $2"

    if [[ $AvailableChoicesString == "" ]]; then
        AvailableChoicesString="$1"
    else
        AvailableChoicesString="$AvailableChoicesString | $1"
    fi
}
#
AskForUserAction(){
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Please select an action " "NoNewLine"; read -p "[ $AvailableChoicesString ]: " UserInput
    if [[ $UserInput == "" ]]; then
        while [[ $UserInput == "" ]]; do
            echo -n "You did not give a choice. Please make a choice "; read -p "[ $AvailableChoicesString ]: " UserInput
        done
    fi
}
##################################################
##################################################
# User Actions
##################################################
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
PrintMenu_InteractiveShell