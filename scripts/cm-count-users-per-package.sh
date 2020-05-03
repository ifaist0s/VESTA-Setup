#!/bin/bash
# Version 2020-05-01
# This script is for Vesta/Hestia Hosting Control Panels
# It will count the users in each hosting package

# Some array declarations
declare -a UsersArray
declare -a Packages

# Check if this is a VESTA or HESTIA installation
[[ -d /usr/local/vesta/ ]] && CPNAME=vesta
[[ -d /usr/local/hestia/ ]] && CPNAME=hestia

mapfile -t UsersArray < <( /usr/local/$CPNAME/bin/v-list-users | awk '{print $1}' | awk '/----/,0' | awk '!/----/' | awk '!/admin/' | awk '!/dns-cluster/' )

for u in "${UsersArray[@]}"
do
	mapfile -t  DomainArray  < <( /usr/local/$CPNAME/bin/v-list-dns-domains "$u" | awk '{print $1}' | awk '/----/,0' | awk '!/----/' )
	Packages+=($( /usr/local/$CPNAME/bin/v-list-user "$u" | grep PACKAGE | awk '{print $2}' ))
done

echo "${Packages[@]}" | tr " " "\n" | sort | uniq -c | awk '{printf("%s\t%s\n",$2,$1)}'
