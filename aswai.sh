#!/bin/bash

SCRIPTNAME="ASWAI"

if [ "$SUDO_USER" = "" ]; then
	echo "$SCRIPTNAME must be run with sudo, because pacman needs root and makepkg cannot be run as root (therefore 'sudo -u \$SUDO_USER makepkg')."
	exit 3
fi

if [ $# = 0 ]; then
	echo "$SCRIPTNAME needs at one argument (package name)."
	exit 1
fi

TARGETPKG="$1"
BUILDDIR="/tmp/$SCRIPTNAME/$TARGETPKG/"

AURBASEURL="https://aur.archlinux.org/packages/"
AURPREFIX="`echo $TARGETPKG | grep -o '^..'`"
TARBALLNAME="$TARGETPKG.tar.gz"

if [ ! -d "$BUILDDIR" ]; then
	echo "Build dir ($BUILDDIR) not found, trying to create it..."
	mkdir -p "$BUILDDIR"
	if [ $? != 0 ]; then
		echo "Failed to create $BUILDDIR"
		echo "Exiting"
		exit 2
	fi
	echo "Success!"
	echo "Moving on."
fi

cd $BUILDDIR

wget "$AURBASEURL/$AURPREFIX/$TARGETPKG/$TARBALLNAME"

tar -xf "$TARBALLNAME"

cd "$TARGETPKG"

makepkg

MADEPKG="`ls -1 | grep '\.pkg\.tar\.xz$'`"

pacman -U "$MADEPKG"

exit 0;
