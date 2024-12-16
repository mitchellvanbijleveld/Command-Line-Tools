#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Plesk/CalculateMailStatistics
####################################################################################################
VAR_UTILITY="Plesk"
VAR_UTILITY_SCRIPT="CalculateMailStatistics"
VAR_UTILITY_SCRIPT_VERSION="2024.12.16-2232"
VAR_UTILITY_SCRIPT_REQUIRED_COMMAND_LINE_TOOLS="basename cat echo find hostname mkdir mktemp printf PrintMessage tr"
####################################################################################################
# UTILITY SCRIPT INFO - Plesk/CalculateMailStatistics
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
VAR_MAIL_DIRECTORY="/var/qmail/mailnames"
VAR_SYSTEM_HOSTNAME=$(hostname)
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
CountMail_FileSystem(){
    # $1 = DOMAIN NAME
    # $2 = EMAIL ADDRESS
    # $3 = MAIL DIRECTORY
    if [[ -d "$VAR_MAIL_DIRECTORY/$1/$2/Maildir/$3" ]]; then
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Count email for $2@$1 in mailbox $3" >&2
        echo $(find "$VAR_MAIL_DIRECTORY/$1/$2/Maildir/$3" -iname "*$VAR_SYSTEM_HOSTNAME*" -type f | wc -l)
    else
        echo 0
    fi
}
#
PrintStatistics_FileSystem(){
    # $1 = DOMAIN NAME
    # $2 - EMAIL ADDRESS
    echo "    $(printf "%-7s\n" Total): $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/ALL"))"
    echo "    $(printf "%-7s\n" Drafts): $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/DRAFTS"))"
    echo "    $(printf "%-7s\n" Notes): $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/NOTES"))"
    echo "    $(printf "%-7s\n" Sent): $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/SENT"))"
    echo "    $(printf "%-7s\n" Spam): $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/SPAM"))"
    echo "    $(printf "%-7s\n" Inbox): $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/INBOX"))"
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
#
##################################################
##################################################
# CALCULATE STATISTICS FILESYSTEM
##################################################
TMP_DIR=$(mktemp -d -t "mitchellvanbijleveld-$VAR_UTILITY-$VAR_UTILITY_SCRIPT-FS.XXXXXXXX")
PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Created Temporary Directory: $TMP_DIR"
#
for var_domain in $VAR_MAIL_DIRECTORY/*; do
    #
    if [[ -d $var_domain ]]; then
        var_domain_basename=$(basename $var_domain)
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Found domain name: $var_domain_basename"
        TMP_DIR_DOMAIN="$TMP_DIR/$var_domain_basename"; mkdir $TMP_DIR_DOMAIN
        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Created temporary directory: $TMP_DIR_DOMAIN"
    else
        continue
    fi
    #
    for var_email_address in $var_domain/*; do
        #
        if [[ -d $var_email_address ]]; then
            var_email_address_basename=$(basename $var_email_address)
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Found email address: $var_email_address_basename"
            TMP_DIR_EMAIL_ADDRESS="$TMP_DIR_DOMAIN/$var_email_address_basename"; mkdir $TMP_DIR_EMAIL_ADDRESS
            PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Created temporary directory: $TMP_DIR_EMAIL_ADDRESS"
        else
            continue
        fi
        #
        VAR_MAIL_COUNT____ALL=$(CountMail_FileSystem "$var_domain_basename" "$var_email_address_basename" "")
        VAR_MAIL_COUNT_DRAFTS=$(CountMail_FileSystem "$var_domain_basename" "$var_email_address_basename" ".Drafts")
        VAR_MAIL_COUNT__NOTES=$(CountMail_FileSystem "$var_domain_basename" "$var_email_address_basename" ".Notes")
        VAR_MAIL_COUNT___SENT=$(CountMail_FileSystem "$var_domain_basename" "$var_email_address_basename" ".Sent")
        VAR_MAIL_COUNT___SPAM=$(CountMail_FileSystem "$var_domain_basename" "$var_email_address_basename" ".Spam")
        VAR_MAIL_COUNT__INBOX=$((VAR_MAIL_COUNT____ALL-VAR_MAIL_COUNT_DRAFTS-VAR_MAIL_COUNT__NOTES-VAR_MAIL_COUNT___SENT-VAR_MAIL_COUNT___SPAM))
        #
        echo $VAR_MAIL_COUNT____ALL > "$TMP_DIR_EMAIL_ADDRESS/ALL"
        echo $VAR_MAIL_COUNT_DRAFTS > "$TMP_DIR_EMAIL_ADDRESS/DRAFTS"
        echo $VAR_MAIL_COUNT__NOTES > "$TMP_DIR_EMAIL_ADDRESS/NOTES"
        echo $VAR_MAIL_COUNT___SENT > "$TMP_DIR_EMAIL_ADDRESS/SENT"
        echo $VAR_MAIL_COUNT___SPAM > "$TMP_DIR_EMAIL_ADDRESS/SPAM"
        echo $VAR_MAIL_COUNT__INBOX > "$TMP_DIR_EMAIL_ADDRESS/INBOX"
    done
done
##################################################
# CALCULATE STATISTICS FILESYSTEM
##################################################
##################################################
#
#
#
#
#
##################################################
##################################################
# PRINT SUMMARY
##################################################
for var_domain in $TMP_DIR/*; do
    if [[ -d $var_domain ]]; then
        var_domain_basename=$(basename $var_domain)
        PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Domain Name: $var_domain_basename"
    else
        continue
    fi
    #
    for var_email_address in $var_domain/*; do
        if [[ -d $var_email_address ]]; then
            var_email_address_basename=$(basename $var_email_address)
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Email Address: $var_email_address_basename@$var_domain_basename"
        else
            PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  No email address found."
            continue
        fi
        PrintStatistics_FileSystem $var_domain_basename $var_email_address_basename
    done
    PrintMessage
done
##################################################
# PRINT SUMMARY
##################################################
##################################################