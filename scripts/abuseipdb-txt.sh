#!/bin/bash
# 2020-07-15-02
# Get AbuseIPDB data in text format and convert to ipset rules for iptables / https://www.abuseipdb.com/
# The script will place a firewall block on all IP addresses found in AbuseIPDB.
# Since AbuseIPDB allows limited amount of times to download the DB, we download the DB
# to another server, place it on a web accessible URL and the rest of the servers get if from there.

DNLURL="abuseipdb_download_URL"   # Change this to the URL of the AbuseIPDB
ABIPDB="/root/abuseipdb.txt"      # Placing AbuseIPDB in /root since the script will be run as root
IPSETL="abuseipdb"                # The name of the ipset rule
unset DLSUCCESS
declare -a abuseipArray
curl=/usr/bin/curl
iptables=/sbin/iptables
ipset=/sbin/ipset

# If crontab entry does not exists add it
crontab -l | grep "$0" > /dev/null 2>&1 || (crontab -l 2>/dev/null; echo "14 04 * * *	/bin/bash /root/$0") | crontab -

# Function to check for valid IP address
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# Check if iptables, ipset and curl exist on the system
if [ -f "$curl" ] && [ -f "$iptables" ] && [ -f "$ipset" ]; then
	# Download abuseipdb.txt from central server
	$curl -s --output $ABIPDB $DNLURL

	# Check if the first line of the downloaded file is an IP address
	if valid_ip "$(head --lines=1 "$ABIPDB")"; then
		# Add all IP addresses to an array
		mapfile -t abuseipArray < <( cat $ABIPDB )

		# Flush ipset if exists, or create if it doesn't
		$ipset flush $IPSETL > /dev/null 2>&1 || $ipset -N $IPSETL iphash

		# Add items to ipset
		for i in "${abuseipArray[@]}"
		do
			$ipset -A $IPSETL "$i" > /dev/null 2>&1
		done

		# Add ipset set to chain if it doen's already exist
		$iptables -n -L | grep $IPSETL > /dev/null 2>&1 || $iptables -I INPUT -m set --match-set $IPSETL src -j DROP
		echo "List $IPSETL updated on $(hostname -f) - $($ipset list $IPSETL -t | grep 'Number of entries')"
	else
		echo Could not download AbuseIPDB from $DNLURL
	fi
else
	echo "You need to have iptables, ipset and curl installed to continue."
fi
