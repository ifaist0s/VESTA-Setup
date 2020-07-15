#!/bin/bash
# 2020-07-15-02
# Get AbuseIPDB data and save to a web accessible URL

APIKEY="change-this-to-your-API"
ABIPDB="change-this-to-a-web-accessible-path/public_html/$(printf '%(%Y-%m-%d)T\n' -1)-abuseipdb.txt"
ABIPOK="change-this-to-a-web-accessible-path/public_html/abuseipdb.txt"
unset DLSUCCESS
# Define command location (useful if run under cron)
curl=/usr/bin/curl
cp=/bin/cp
rm=/bin/rm

# Get the data with abuseipdb API Key
$curl -s -G https://api.abuseipdb.com/api/v2/blacklist \
  -d confidenceMinimum=100 \
  -H "Key: $APIKEY" \
  -H "Accept: text/plain" > "$ABIPDB" && DLSUCCESS=1 || DLSUCCESS=0

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

if [ "$DLSUCCESS" -eq 1 ]; then
	# Check if the first line of the downloaded file is an IP address and make a copy (keep older DBs)
	if valid_ip "$(head --lines=1 "$ABIPDB")"; then
		$cp "$ABIPDB" "$ABIPOK" && echo File "$ABIPDB" has been downloaded and verified.
	else
		# Delete if the first line is not an IP address (for example when it's an error message, html code, etc)
		$rm "$ABIPDB" && echo Downloaded AbuseIPDB was invalid and has been deleted.
	fi
else
	echo Could not download AbuseIPDB from server.
fi
