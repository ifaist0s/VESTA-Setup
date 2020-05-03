#!/bin/bash
# Version 2020-05-03-01
# COINMASTER
# This script is for Vesta/Hestia Hosting Control Panels

# Show the nice Banner
clear
base64 -d <<<"H4sICHXSmF0CA3Rlc3RmaWxlLnR4dABNjbsNADEIQ3umcAkVC1ny/lsckN9JiZ04zwSQhJZjpWvt/fQBTw1Zh/CphHd
cFzo6YlYGpERsbgM6HZrDtbqTDFIlHx3PAoJgYcQMRlSygLR+6Jqu9Sy2JnP8bmX/FvhjZh9Co/JsBQEAAA==" | gunzip

echo ================ USAGE INSTRUCTIONS ================
echo Use this command without any arguments to see
echo a list of all the domains hosted on this server.
echo
echo Use the EXP command line argument to also display
echo the user and expiration date of each domain
echo ====================================================

# Find all server domains and put then in an array
declare -a UsersArray
declare -a DomainArray
declare -a ListFinal
mapfile -t UsersArray < <( v-list-users | awk '{print $1}' | awk '/----/,0' | awk '!/----/' | awk '!/admin/' | awk '!/dns-cluster/' )

if [ "$1" == "EXP" ]; then
	printf "%-12s | %-10s | %s\n" "Expiry" "User" "Domain"
	for i in "${UsersArray[@]}"
	do
		mapfile -t  DomainArray  < <( v-list-dns-domains "$i" | awk '{print $1}' | awk '/----/,0' | awk '!/----/' )
		for d in "${DomainArray[@]}"
		do
			#echo -e $(v-list-dns-domain $i $d | grep EXP)' \t '$i' \t '$d
			#printf "%-12s | %-10s | %-50s %s\n" "$(v-list-dns-domain $i $d | awk '{print $2}' | awk 'NR==5')" "$i" "$d"
			ListFinal+=($( v-list-dns-domain "$i" "$d" | awk '{print $2}' | awk 'NR==5' && echo "$i" && echo "$d" ))
			DomainExpiry=$( v-list-dns-domain "$i" "$d" | awk '{print $2}' | awk 'NR==5' )
			CurrentDate=$(date +%Y-%m-%d)
			if [[ "$CurrentDate" > "$DomainExpiry" ]] ;
			then
				echo "DOMAIN $d EXPIRED AT $DomainExpiry !"
			fi
		done
	done
	printf "%-12s | %-10s | %s\n" "${ListFinal[@]}" | sort
else
	for i in "${UsersArray[@]}"
	do
		v-list-dns-domains "$i" | awk '{print $1}' | awk '/----/,0' | awk '!/----/'
	done
fi
