#!/bin/bash
# 2020-02-09-01
# This script will list all the user databases, along with some more info

# Some array declarations
declare -a UsersArray

# Check if this is a VESTA or HESTIA installation
[[ -d /usr/local/vesta/ ]] && CPNAME=vesta && export VESTA=/usr/local/vesta
[[ -d /usr/local/hestia/ ]] && CPNAME=hestia && export HESTIA=/usr/local/hestia

# Find all server users and put then in an array
mapfile -t UsersArray < <( /usr/local/$CPNAME/bin/v-list-users | awk '{print $1}' | awk '/----/,0' | awk '!/----/' | awk '!/admin/' | awk '!/dns-cluster/' )

# Print just the header of the list
/usr/local/$CPNAME/bin/v-list-databases admin | awk 'NR == 1'| awk '{printf "%-20s  %-20s %-10s %-7s %-5s %-5s %-15s \n", $1,$2,$3,$4,$5,$6,$7}'
/usr/local/$CPNAME/bin/v-list-databases admin | awk 'NR == 2'| awk '{printf "%-20s  %-20s %-10s %-7s %-5s %-5s %-15s \n", $1,$2,$3,$4,$5,$6,$7}'
# Go through all users / add results to database
for u in "${UsersArray[@]}"
do
	OUTPUT+="$( /usr/local/$CPNAME/bin/v-list-databases $u | awk '/----/,0' | awk '!/----/' )\n"
done
# Print, remove blank lines and sort reverse numbering on 7th column (DISK)
echo -e "${OUTPUT[@]}" | awk '{printf "%-20s  %-20s %-10s %-7s %-5s %-5s %-15s \n", $1,$2,$3,$4,$5,$6,$7}' | awk NF | sort -k5 -rn 
