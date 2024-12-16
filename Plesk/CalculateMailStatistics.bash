#!/bin/bash
#
####################################################################################################
####################################################################################################
# UTILITY SCRIPT INFO - Plesk/CalculateMailStatistics
####################################################################################################
VAR_UTILITY="Plesk"
VAR_UTILITY_SCRIPT="CalculateMailStatistics"
VAR_UTILITY_SCRIPT_VERSION="2024.12.16-2306"
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
        "--PRINT-STATISTICS")
            while [[ $2 != "--"* && $2 != "" ]]; do
                case $2 in
                    "filesystem") 
                        PrintMessage "DEBUG" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Script will print filesystem statistics..."
                        PRINT_STATISTICS_FILESYSTEM=1
                    ;;
                esac
                shift
            done
        ;;
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
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "    Total  : $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/___ALL"))"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "    Drafts : $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/DRAFTS"))"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "    Notes  : $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/_NOTES"))"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "    Sent   : $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/__SENT"))"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "    Spam   : $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/__SPAM"))"
    PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "    Inbox  : $(printf "%6s\n" $(cat "$TMP_DIR/$1/$2/_INBOX"))"
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
echo 0 > "$TMP_DIR/___ALL"
echo 0 > "$TMP_DIR/DRAFTS"
echo 0 > "$TMP_DIR/_NOTES"
echo 0 > "$TMP_DIR/__SENT"
echo 0 > "$TMP_DIR/__SPAM"
echo 0 > "$TMP_DIR/_INBOX"
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
        echo $VAR_MAIL_COUNT____ALL > "$TMP_DIR_EMAIL_ADDRESS/___ALL"
        echo $VAR_MAIL_COUNT_DRAFTS > "$TMP_DIR_EMAIL_ADDRESS/DRAFTS"
        echo $VAR_MAIL_COUNT__NOTES > "$TMP_DIR_EMAIL_ADDRESS/_NOTES"
        echo $VAR_MAIL_COUNT___SENT > "$TMP_DIR_EMAIL_ADDRESS/__SENT"
        echo $VAR_MAIL_COUNT___SPAM > "$TMP_DIR_EMAIL_ADDRESS/__SPAM"
        echo $VAR_MAIL_COUNT__INBOX > "$TMP_DIR_EMAIL_ADDRESS/_INBOX"
        #
        echo $(($(cat "$TMP_DIR/___ALL")+$VAR_MAIL_COUNT____ALL)) > "$TMP_DIR/___ALL"
        echo $(($(cat "$TMP_DIR/DRAFTS")+$VAR_MAIL_COUNT_DRAFTS)) > "$TMP_DIR/DRAFTS"
        echo $(($(cat "$TMP_DIR/_NOTES")+$VAR_MAIL_COUNT__NOTES)) > "$TMP_DIR/_NOTES"
        echo $(($(cat "$TMP_DIR/__SENT")+$VAR_MAIL_COUNT___SENT)) > "$TMP_DIR/__SENT"
        echo $(($(cat "$TMP_DIR/__SPAM")+$VAR_MAIL_COUNT___SPAM)) > "$TMP_DIR/__SPAM"
        echo $(($(cat "$TMP_DIR/_INBOX")+$VAR_MAIL_COUNT__INBOX)) > "$TMP_DIR/_INBOX"
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
# PRINT STATISTICS FILESYSTEM
##################################################
if [[ $PRINT_STATISTICS_FILESYSTEM -eq 1 ]]; then
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
fi
##################################################
# PRINT STATISTICS FILESYSTEM
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
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "Mail Statistics Summary"
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Total  : $(printf "%6s\n" $(cat "$TMP_DIR/___ALL"))"
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Drafts : $(printf "%6s\n" $(cat "$TMP_DIR/DRAFTS"))"
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Notes  : $(printf "%6s\n" $(cat "$TMP_DIR/_NOTES"))"
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Sent   : $(printf "%6s\n" $(cat "$TMP_DIR/__SENT"))"
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Spam   : $(printf "%6s\n" $(cat "$TMP_DIR/__SPAM"))"
PrintMessage "INFO" "$VAR_UTILITY" "$VAR_UTILITY_SCRIPT" "  - Inbox  : $(printf "%6s\n" $(cat "$TMP_DIR/_INBOX"))"
##################################################
# PRINT SUMMARY
##################################################
##################################################