#!/bin/bash
# This script reads all of the VESTA packages
# and displays the number of users in each package

echo ---------------------
echo GET ALLOCATED STORAGE
echo ---------------------

# Assign package names in array and then read the array
dirlist=(/usr/local/vesta/data/packages/*.pkg)
# Loop through packages and print number of users
for i in "${dirlist[@]}"
do
        PACKAGE=$(echo $i | cut -c32-50 | cut -d "." -f 1)
        USERS=$(v-list-users | grep $PACKAGE | wc -l)
        echo -e Package $PACKAGE: ' \t '$USERS users.
done
