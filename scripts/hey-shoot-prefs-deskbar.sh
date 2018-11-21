#!/bin/bash

## Hey-shoot Template ##

## Developed by BachToTheFuture
## for GCI 2018

## A template script for an automated screenshot taking
## for Haiku's User Guide. Your welcome!

## Please rename this file to "hey-shoot-[imagename].sh".
## Usage		: hey-shoot-[imagename].sh [path-to-userguide]
## Example usage: hey-shoot-activitymonitor.sh userguide/en

## Basic information ##
# targetName	: This is the name of the app you are going to open
# imageName 	: This is the name of the image that you will replace
#				| ** Extensions required **
# imageSubPath	: The parent folder of the image

targetName="Deskbar"
imageName="prefs-deskbar.png"
imageSubPath="deskbar-images"


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
	cp ~/config/settings/deskbar/settings "$tempDir"

	# Copy default settings to deskbar & rename to "settings"
	cp "$workfileDir/deskbar.default-settings" \
		~/config/settings/deskbar/settings

	# Restart Deskbar!
	kill $targetName

	# Open pref window and take screenshot.
	$targetName &
	waitfor "w>$targetName preferences"
}

## Actions after screenshots ##
# Close the apps opened by this script.
function endAction {

	# Move the user's backup back into configs
	mv "$tempDir/settings" ~/config/settings/deskbar

	# Restart Deskbar to reload user configs
	kill $targetName
	Deskbar
	hey Deskbar set Minimize of Window "Deskbar preferences" to "bool(true)"
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
if [ -z $1 ]; then
	echo
	echo "Usage  : hey-shoot-[imagename].sh [path-to-userguide]"
	echo "Example: hey-shoot-activitymonitor.sh userguide/en"
	echo
	exit
fi

# Get arguments if there are any
basePath=$1

# Go to userguide directory and find the image
imagePath=`find $basePath/images/$imageSubPath -name "$imageName"`

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
imageFormat="${newImagePath#*.}"

# Check if edit is needed
if [ $editNeeded -eq 1 ]; then
	echo "[Warning] This image requires editing"
	newImagePath="$imagePath"_needs_editing
fi

# Rename the original image
mv "$imagePath" "$imagePath.orig"
echo "Renamed image to $imagePath.orig"

# Take a screenshot!
screenshot $screenshotArgs -s --format=imageFormat "$newImagePath"

# Perform the end action
endAction

# Output paths of new and old image
echo
echo "Original: $imagePath.orig"
echo "New     : $newImagePath"
echo
exit
