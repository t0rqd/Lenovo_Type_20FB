#!/bin/bash

# Because the X1 Carbon (4th Gen) has a broken UEFI, some serious
# hacks are required to be able to dual boot back into this Linux
# instance. Here we attempt to make this possible by using the
# BootNext flag with efibootmgr as changing BootOrder doesn't work.

PATH=/sbin:/usr/sbin:/bin:/usr/bin

NEXT=`efibootmgr | grep BootNext | cut -c11-14`
DEB=`efibootmgr | grep debian | cut -c5-8`
ORDER=`efibootmgr | grep BootOrder | cut -c12-`

# Check to see if the last time we set BootOrder stuck:

echo $ORDER | grep -q $DEB
TEST=`echo $?`

if [ "$TEST" = "0" ];
then
	exit
else

	# If we got here, the efibootmgr is broken still, so we'll set
	# the "BootNext" variable which does survive a reboot.

	# Check if BootNext is set and bail, or set it

	if [ "$NEXT" != "$DEB" ];
	then
		efibootmgr -n $DEB
	else
		exit
	fi

	# Here we'll reset the boot order as well

	efibootmgr -O
	efibootmgr -o $DEB,$ORDER
fi

