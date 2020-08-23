#!/bin/bash

# Variable of directory that we'll check the size of
DIR='/home'

# Email address we'll send alerts to
MAILTO='[CHANGE ME]'

# Variable SUBJECT holds email's subject
SUBJECT="SERVER STATUS: $(hostname -f)"

# Check if mailx is installed and assign it's path to a variable
MAILX="$(command -v mailx)"

# Define the log file / Same name as script file but with .log extension
LOGFILE=$0.log

# rsync variables (ssh key, local backup directory, remote backup directory, backup server)
RSYNKEY=$HOME/rsa-key-backup.key
LOCABAK=/backup/
REMOBAK=/v-backup
BAKFOLD=[CHANGE ME]		# No slashes
BAKSERV=[CHANGE ME]		# Hostname or IP address
BAKUSER=[CHANGE ME]		# Hostname or IP address

# Manual set the environment so it accepts non ASCII characters https://stackoverflow.com/a/18717024/5211506
export LC_CTYPE="el_GR.UTF-8"

# Check if this is a VESTA or HESTIA installation
[[ -d /usr/local/vesta/ ]] && CPNAME=vesta
[[ -d /usr/local/hestia/ ]] && CPNAME=hestia

# Throw error and exit if mailx is not installed
if [[ $MAILX == "" ]]
	then
	  echo "Please install mailx"
	#Here we warn user that mailx not installed
	  exit 1
	#Here we will exit from script
fi

# This will print space usage by each directory inside directory $DIR, and after MAILX will send email with SUBJECT to MAILTO
	{ echo "##### DISK USAGE FOR $DIR #####" ; du -sh ${DIR}/* | sort -hr ; echo "" ; } >> "$LOGFILE" 2>&1

# This will print inode usage for /home directory
	{ echo "##### INODE USAGE #####" ; df -hi ; echo "" ; } >> "$LOGFILE" 2>&1

# Check MailQueue
	{ echo "##### CHECKING THE MAIL QUEUE #####" ; /usr/sbin/exim -bp | /usr/sbin/exiqsumm ; } >> "$LOGFILE" 2>&1

# Check free space
	{ echo "##### CHECKING FREE SPACE #####" ; df -Tha --total ; echo "" ; } >> "$LOGFILE" 2>&1

# Check free memory
	{ echo "##### CHECKING FREE MEMORY #####" ; free -mt ; echo "" ; } >> "$LOGFILE" 2>&1

# Checking freespace before rsync rsync
	{ echo "##### CHECKING FREE SPACE ON REMOTE BACKUP DEVICE #####" ; ssh $BAKUSER@$BAKSERV -i $RSYNKEY "df -h" ; } >> "$LOGFILE" 2>&1
	
# Perform rsync
	{ echo "" ; echo "##### CHECKING RSYNC BACKUP #####" ; echo "" ; rsync -ahv --no-g -e "ssh -p 22 -i $RSYNKEY" $LOCABAK $BAKUSER@$BAKSERV:$REMOBAK/$BAKFOLD/"$(hostname -f)" ; echo "" ; } >> "$LOGFILE" 2>&1

# Check fail2ban
	{ echo "##### CHECKING FAIL2BAN #####" ; /usr/sbin/service fail2ban status ; echo "" ; } >> "$LOGFILE" 2>&1
	{ echo "##### CHECKING JAIL SSH #####" ; fail2ban-client status ssh-iptables ; echo "" ; } >> "$LOGFILE" 2>&1
	{ echo "##### CHECKING JAIL DOVECOT #####" ; fail2ban-client status dovecot-iptables ; echo "" ; } >> "$LOGFILE" 2>&1
	{ echo "##### CHECKING JAIL EXIM #####" ; fail2ban-client status exim-iptables ; echo "" ; } >> "$LOGFILE" 2>&1
	{ echo "##### CHECKING JAIL MYSQL #####" ; fail2ban-client status mysqld-iptables ; echo "" ; } >> "$LOGFILE" 2>&1
	{ echo "##### CHECKING JAIL VSFTPD #####" ; fail2ban-client status vsftpd-iptables ; echo "" ; } >> "$LOGFILE" 2>&1
	{ echo "##### CHECKING JAIL VESTA/HESTIA #####" ; fail2ban-client status $CPNAME-iptables ; echo "" ; } >> "$LOGFILE" 2>&1
	if [ $CPNAME = "hestia" ]; then
		{ echo "##### CHECKING JAIL RECIDIVE #####" ; fail2ban-client status recidive ; echo "" ; } >> "$LOGFILE" 2>&1
	fi

# Check the number of outgoing messages per user
	{ echo "##### CHECKING NUMBER OF MESSAGES PER USER #####" ; grep '<=' /var/log/exim4/mainlog | awk '{print $5}' | grep \@ | sort | uniq -c | sort -nrk1 ; echo "" ; } >> "$LOGFILE" 2>&1

# Check failures in DNS
	{ echo "##### CHECKING DNS FAILURES #####" ; tail -c 8192 /var/log/syslog | grep denied ; echo "" ; } >> "$LOGFILE" 2>&1

# Clean PHP session files older than 24h (Vesta only / Hestia has a cron job for that
	if [ $CPNAME = "vesta" ]; then
		for d in /home/*; do /usr/bin/find "$d"/tmp/sess_* -mmin +1440 -delete; done &> /dev/null
	fi

# Send email alert
	$MAILX -r root -s "$SUBJECT" "$MAILTO" < "$LOGFILE" 2>&1
