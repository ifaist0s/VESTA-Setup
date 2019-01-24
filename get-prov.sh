#!/bin/bash
echo ---------------------
echo GET PROVISIONED SPACE
echo ---------------------

# Define VESTA Package names
P1="VSSD-S"
P2="VSSD-M"
P3="VSSD-L"
P4="VSSD-XL"
# for future use
# find /usr/local/vesta/data/packages/*  -printf "%f\n"
# for n in /usr/local/vesta/data/packages/*; do printf '%s\n' "$n"; done

P1L="$(v-list-users | grep $P1 | wc -l)"
P2L="$(v-list-users | grep $P2 | wc -l)"
P3L="$(v-list-users | grep $P3 | wc -l)"
P4L="$(v-list-users | grep $P4 | wc -l)"

echo -e Users provisioned in Package $P1:' \t '$P1L
echo -e Users provisioned in Package $P2:' \t '$P2L
echo -e Users provisioned in Package $P3:' \t '$P3L
echo -e Users provisioned in Package $P4:' \t '$P4L
