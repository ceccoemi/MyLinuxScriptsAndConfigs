#!/bin/bash

function copyScript {
	cp $(dirname $0)/$file $HOME/bin
	chmod 744 $HOME/bin/$1
	chgrp $(who | awk '{print $1}') "$HOME/bin/$1"
	chown $(who | awk '{print $1}') "$HOME/bin/$1"
}

if [ $(id -u) != 0 ]; then
	echo "WARNING: running this script without sudo \
will not install those scripts that need superuser privileges"
fi

if [ ! -d "$HOME/bin" ] ; then
	echo "Setting up $HOME/bin"
	mkdir "$HOME/bin" -m 755
	chgrp $(who | awk '{print $1}') "$HOME/bin"
	chown $(who | awk '{print $1}') "$HOME/bin"
	if [ ! $(grep 'PATH="\$HOME/bin:\$PATH"' $HOME/.profile) ] ; then
		# Add $HOME/bin folder to the executable path
		echo "" >> $HOME/.profile
		echo "# set PATH so it includes user's private bin if it exists" >> $HOME/.profile
		echo 'if [ -d "$HOME/bin" ] ; then' >> "$HOME/.profile"
		echo '    PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
		echo 'fi' >> "$HOME/.profile"

		source .profile

		echo "Added $HOME/bin folder to PATH"
	fi
else
	echo "$HOME/bin directory already found, assuming that is already in PATH"
fi

echo "Copying scripts to $HOME/bin"
# Here add the scripts that must be executed with sudo
sudoScripts="up"
if [ $(id -u) = 0 ]; then
	# If the script is executed with sudo
	for file in $(ls $(dirname "$0")); do
		if [ $file != $(basename "$0") ]; then
			copyScript $file
			if [ "$(echo $sudoScripts | grep $file)" ]; then
				# For sudo scripts make a link to /usr/local/sbin, so they are callable with sudo
				ln -svi "$HOME/bin/$file" "/usr/local/sbin/$file"
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
