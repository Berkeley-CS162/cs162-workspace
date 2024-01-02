#!/bin/bash

set -e

SRC=/workspace

if [ -f "/home/workspace/.version" ]; then
	# File exists
	if cmp -s "/home/workspace/.version" "/workspace/.version"; then
		# Files are identical, do nothing
		echo "No updates detected!"
	else
		echo "Update detected!"
		# update-workspace
		# File do not match
		# Get list of existing files that don't match
		# Confirmation for override
		# If yes, then proceed to override, if no, run update-workspace to retry
	fi
else
	# File does not exist
	echo "It looks like this is the first time you're using the workspace. Preparing home directory..."
	sudo rsync -rahWt --remove-source-files --exclude '.version' --info=progress2 --info=name0 /workspace/ /home/workspace
	sudo rsync -rahWt --remove-source-files --info=progress2 --info=name0 /workspace/.version /home/workspace
	echo "Setting up workspace backup..."
	pushd /home/workspace
		git init 2>&1 > /dev/null
		git config user.name "CS 162 Workspace Backup" 2>&1 > /dev/null
		git config user.email "cs162@eecs.berkeley.edu" 2>&1 > /dev/null
		git add -A && git commit -m "Backup Date $(date)" 2>&1 > /dev/null
	popd
fi

sudo service ssh start

echo "Docker workspace is ready!"

cd /home/workspace

/bin/bash
