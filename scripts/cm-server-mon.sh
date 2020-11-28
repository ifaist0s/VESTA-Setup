#!/bin/bash
# 2020-11-28-01

# Variable of directory that we'll check the size of
DIR='/home'

# Email address we'll send alerts to
MAILTO="[CHANGE ME]"

# Variable SUBJECT holds email's subject
SUBJECT="SERVER STATUS: $(hostname -f)"

# Check if mailx is installed and assign it's path to a variable
MAILX="$(command -v mailx)"

# Define the log file / Same name as script file but with .log extension
LOGFILE=$0.log
USEBAKSERVER=B			# Use different Backup Servers. In case one is down, quickly switch to another.

# rsync variables (ssh key, local backup directory, remote backup directory, backup server)
LOCABAK=/backup/		# Local directory to be backed up

# Manual set the environment so it accepts non ASCII characters https://stackoverflow.com/a/18717024/5211506
export LC_CTYPE="el_GR.utf8"

# Check if this is a VESTA or HESTIA installation
[[ -d /usr/local/vesta/ ]] && CPNAME=vesta
[[ -d /usr/local/hestia/ ]] && CPNAME=hestia

# Throw error and exit if mailx is not installed
if [[ $MAILX == "" ]]
	then
	  echo "Please install mailx (apt install mailutils)"
	#Here we warn user that mailx not installed
	  exit 1
	#Here we will exit from script
fi

# This will print the space usage by each directory inside directory $DIR
	{ echo "##### DISK USAGE FOR $DIR #####" ; du -sh ${DIR}/* | sort -hr ; echo "" ; } > "$LOGFILE" 2>&1

# This will print inode usage for /home directory
	{ echo "##### INODE USAGE #####" ; df -hi ; echo "" ; } >> "$LOGFILE" 2>&1

# Check MailQueue
	{ echo "##### CHECKING THE MAIL QUEUE #####" ; /usr/sbin/exim -bp | /usr/sbin/exiqsumm ; } >> "$LOGFILE" 2>&1

# Check free space
	{ echo "##### CHECKING FREE SPACE #####" ; df -Tha --total ; echo "" ; } >> "$LOGFILE" 2>&1

# Check free memory
	{ echo "##### CHECKING FREE MEMORY #####" ; free -mth ; echo "" ; } >> "$LOGFILE" 2>&1

# Rsync to different server based on VARIABLE selection
case $USEBAKSERVER in
	A)       
		RSYNKEY=[CHANGE ME]		# Key file name with full path. Mind permissions on file
		REMOBAK=[CHANGE ME]		# No trailing slash
		BAKFOLD=[CHANGE ME]		# No slashes
		BAKSERV=[CHANGE ME]		# Hostname or IP address
		BAKPORT=[CHANGE ME]		# Port the rsync/ssh server runs on
		BAKUSER=[CHANGE ME]		# Hostname or IP address
		# Checking freespace before rsync
		{ echo "##### CHECKING FREE SPACE ON REMOTE BACKUP DEVICE #####" ; ssh "$BAKUSER"@"$BAKSERV" -i "$RSYNKEY" "df -h" ; echo "" ; } >> "$LOGFILE" 2>&1
		;;
	B)
		RSYNKEY=[CHANGE ME]		# Key file name with full path. Mind permissions on file
		REMOBAK=[CHANGE ME]		# No trailing slash
		BAKFOLD=[CHANGE ME]		# No slashes
		BAKSERV=[CHANGE ME]		# Hostname or IP address
		BAKPORT=[CHANGE ME]		# Port the rsync/ssh server runs on
		BAKUSER=[CHANGE ME]		# Hostname or IP address
		;;            
	*)              
esac 
	
# Perform rsync
	{ echo "" ; echo "##### CHECKING RSYNC BACKUP #####" ; echo "" ; rsync -ahv --no-g -e "ssh -p $BAKPORT -i $RSYNKEY" "$LOCABAK" "$BAKUSER"@"$BAKSERV":"$REMOBAK"/"$BAKFOLD"/"$(hostname -f)" ; echo "" ; } >> "$LOGFILE" 2>&1

# Define fail2ban check function
	check_f2b() {
		if /usr/bin/fail2ban-client status | grep "$1" > /dev/null 2>&1 ; then
			{ echo "##### CHECKING JAIL $1 #####" ; fail2ban-client status "$1" ; echo "" ; } >> "$LOGFILE" 2>&1 ;
			else
			{ echo "##### JAIL $1 DOES NOT EXIST #####" ; echo "" ; } >> "$LOGFILE" 2>&1 ;
		fi
	}

# Perform the actual fail2ban checking
	check_f2b ssh-iptables
	check_f2b dovecot-iptables
	check_f2b exim-iptables
	check_f2b mysqld-iptables
	check_f2b vsftpd-iptables
	check_f2b $CPNAME-iptables
	if [ $CPNAME = "hestia" ]; then
		check_f2b recidive
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
