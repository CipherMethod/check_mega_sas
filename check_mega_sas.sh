#!/bin/sh
#
# check_mega_sas.sh - Search for MegaRAID SAS controller and alert for failed drives.
#                     Originally written for Broadcom/LSI MegaRAID Tri-Mode SAS3516 on Red Hat Enterprise Linux 7
# 20200501 jah      - Created by Jamey Hopkins
#

CLI="megacli"
MODULE="megaraid_sas"

MRPRESENT=`lsmod | grep $MODULE`
STATUS=$?
[ "$STATUS" = "1" ] && printf "ERROR: $MODULE module not found" && exit 2

MEGACLIPRESENT=`which $CLI`
STATUS=$?
[ "$STATUS" = "1" ] && printf "ERROR: $CLI command not found" && exit 2

DRIVESTATUS=`sudo /usr/sbin/megacli -PDList -aALL -NoLog | grep "Firmware state"`
DTOTAL=`printf "$DRIVESTATUS\n\r" | wc -l`
OTOTAL=`printf "$DRIVESTATUS\n\r" | grep "Online, Spun Up" | wc -l`

[ $OTOTAL -ne $DTOTAL ] && printf "ERROR" || printf "OK"

printf ": Drives $OTOTAL/$DTOTAL\r\n"
printf "$DRIVESTATUS\r\n"

[ $OTOTAL -ne $DTOTAL ] && exit 2 || exit 0

