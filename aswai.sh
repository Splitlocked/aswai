#!/bin/bash

SCRIPTNAME="ASWAI"

if [ $# = 0 ]; then
	echo "$SCRIPTNAME needs at one argument (package name)."
	exit 1
fi

TARGETPKG="$1"
BUILDDIR="$HOME/.asai/$TARGETPKG/"

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

sudo pacman -U "$MADEPKG"

exit 0;
