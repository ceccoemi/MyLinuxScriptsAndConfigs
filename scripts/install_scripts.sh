#!/bin/bash

REAL_HOME="/home/$(who | awk '{print $1}')"

function copyScript {
	cp $(dirname $0)/$file $REAL_HOME/bin
	chmod 744 $REAL_HOME/bin/$1
	chgrp $(who | awk '{print $1}') "$REAL_HOME/bin/$1"
	chown $(who | awk '{print $1}') "$REAL_HOME/bin/$1"
}

if [ $(id -u) != 0 ]; then
	echo "WARNING: running this script without sudo \
will not install those scripts that need superuser privileges"
fi

if [ ! -d "$REAL_HOME/bin" ] ; then
	echo "Setting up $REAL_HOME/bin"
	mkdir "$REAL_HOME/bin" -m 755
	chgrp $(who | awk '{print $1}') "$REAL_HOME/bin"
	chown $(who | awk '{print $1}') "$REAL_HOME/bin"
	if [ ! $(grep 'PATH="\$REAL_HOME/bin:\$PATH"' $REAL_HOME/.profile) ] ; then
		# Add $REAL_HOME/bin folder to the executable path
		echo "" >> $REAL_HOME/.profile
		echo "# set PATH so it includes user's private bin if it exists" >> $REAL_HOME/.profile
		echo 'if [ -d "$REAL_HOME/bin" ] ; then' >> "$REAL_HOME/.profile"
		echo '    PATH="$REAL_HOME/bin:$PATH"' >> "$REAL_HOME/.profile"
		echo 'fi' >> "$REAL_HOME/.profile"

		source "$REAL_HOME/.profile"

		echo "Added $REAL_HOME/bin folder to PATH"
	fi
else
	echo "$REAL_HOME/bin directory already found, assuming that is already in PATH"
fi

echo "Copying scripts to $REAL_HOME/bin"
# Here add the scripts that must be executed with sudo
sudoScripts="up"
if [ $(id -u) = 0 ]; then
	# If the script is executed with sudo
	for file in $(ls $(dirname "$0")); do
		if [ $file != $(basename "$0") ]; then
			copyScript $file
			if [ "$(echo $sudoScripts | grep $file)" ]; then
				# For sudo scripts make a link to /usr/local/sbin, so they are callable with sudo
				ln -svi "$REAL_HOME/bin/$file" "/usr/local/sbin/$file"
			fi
		fi
	done
else
	# If the script is not executed with sudo
	for file in $(ls $(dirname "$0")); do
		if [ "$file" != $(basename "$0") ] && [ ! "$(echo $sudoScripts | grep $file)" ]; then
			copyScript "$file"
		fi
	done
fi

echo "Done"
