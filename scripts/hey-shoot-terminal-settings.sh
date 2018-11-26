#!/bin/bash

## Hey-shoot Template ##

## Developed by BachToTheFuture
## for GCI 2018

## A template script for an automated screenshot taking
## for Haiku's User Guide.

## Please rename this file to "hey-shoot-[imagename].sh".
## Usage		: hey-shoot-[imagename].sh [path-to-userguide]
## Example usage: hey-shoot-activitymonitor.sh userguide/en

## Basic information ##
# targetName	: This is the name of the app you are going to open
# imageName 	: This is the name of the image that you will replace
#				| ** Extensions required **
# imageSubPath	: The parent folder of the image

targetName="Terminal"
imageName="terminal-settings.png"
imageSubPath="apps-images"


## Configuration ##
# editNeeded		 : Set to 1 if picture needs to be edited
# screenshotArgs	 : Arguments for screenshot CLI command.
#					 | Silent mode already enabled.
# workfileDir		 : Path to "workfile" folder
# tempDir			 : Path to "tmp" folder

editNeeded=0
screenshotArgs="--window --border"
workfileDir="../workfiles"
tempDir="/tmp"


## Preparing the app for a screenshot ##
# Use `hey` to rearrange windows, open menus, etc...
function prepareAction {
	# Backup user settings to workfiles
	cp ~/config/settings/Terminal/Default "$tempDir"
	cp ~/config/settings/Terminal/Windows "$tempDir"

	# Copy default settings & rename
	cp "$workfileDir/terminal.default-settings" \
		~/config/settings/Terminal/Default
	# Make a new terminal window with a specified name for
	# making life easier.
	Terminal -t Test &
	waitfor "w>Test"

	# The copied Defaults file should let the "Test" terminal
	# have default settings.
	# Open pref window and take screenshot.
	hey -o "$targetName" 'MPre' Window "Test"
	waitfor "w>$targetName settings"
}

## Actions after screenshots ##
# Close the apps opened by this script.
function endAction {
	# Move the user's backup back into configs
	mv "$tempDir/Default" ~/config/settings/Terminal
	mv "$tempDir/Windows" ~/config/settings/Terminal
	# Restart Terminal to reload user configs
	hey -o Terminal quit Window "Test"
}

# Useful function for delaying actions
function delay {
	# Please replace 0.5 with a number that suits
	# your system. Some machines run faster than others
	# and require more delay.
	sleep 0.5
}


## END OF EDITABLE SECTION ##

# Show help if a user runs the script without arguments
if [ -z "$1" ]; then
	echo
	echo "Usage  : hey-shoot-[imagename].sh [path-to-userguide]"
	echo "Example: hey-shoot-activitymonitor.sh userguide/en"
	echo
	exit
fi

# Get arguments if there are any
basePath="$1"

# Go to userguide directory and find the image
imagePath=$(find "$basePath/images/$imageSubPath" -name "$imageName")

# Check if the image file exists.
if [ -z "$imagePath" ]; then
	echo "[Error] Could not find image in \"$basePath/images/$imageSubPath\""
	exit
else
	echo "Image found in $imagePath"
fi

# Prepare the app for a screenshot
prepareAction

# Delay for few seconds...
delay

# Get the new image path
newImagePath="$imagePath"

# Get format of image
imageFormat="${imageName#*.}"
echo $imageFormat
# Check if edit is needed
if [ $editNeeded -eq 1 ]; then
	echo "[Warning] This image requires editing"
	newImagePath="$imagePath"_needs_editing
fi

# Rename the original image
mv "$imagePath" "$imagePath.orig"
echo "Renamed image to $imagePath.orig"

# Take a screenshot!
screenshot $screenshotArgs -s --format=$imageFormat "$newImagePath"

# Output paths of new and old image
echo
echo "Original: $imagePath.orig"
echo "New     : $newImagePath"
echo

# Perform the end action
endAction
exit
