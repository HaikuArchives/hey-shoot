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
# category		: The parent folder of the image

targetName=""
imageName=""
category=""


## Configuration ##
# targetDir			 : The directory to your target app/prefs
# editNeeded		 : Set to 1 if picture needs to be edited
# screenshotArgs	 : Arguments for screenshot CLI command.
#					 | Silent mode already enabled.

targetDir="/boot/system/apps"
editNeeded=0
screenshotArgs="--window --border"


## Preparing the app for a screenshot ##
# Use `hey` to rearrange windows, open menus, etc...
function prepareAction {
	$targetDir/$targetName &
	waitfor $targetName
}

## Actions after screenshots ##
# Close the apps opened by this script.
# The target app/pref is closed by default.
function endAction {
	hey $targetName quit
}


## END OF EDITABLE SECTION ##
# Show help if a user runs the script without arguments
if [ -z $1 ]; then
	echo
	echo "Hey-shoot Help"
	echo "==============="
	echo "[Usage  ] $0 {path-to-userguide-lang-abbrev}"
	echo "[Example] $0 /boot/system/documentation/userguide/en"
	echo
	exit
fi
# Get arguments if there are any
basePath=$1
# Go to userguide directory and find the image
imagePath=`find $basePath/images/$category -name "$imageName"`
# Check if the image file exists.
if [ -z "$imagePath" ]; then
	echo "[Error] Could not find image in \"$basePath/images/$category\""
	exit
else
	echo "Image found in $imagePath"
	mv $imagePath "$imagePath.orig"
	echo "Renamed image to $imagePath.orig"
fi
# Run the app.
prepareAction
# Delay for few seconds...
sleep 0.5
newImagePath=$imagePath
# Get format of image
imageFormat="${newImagePath#*.}"
# Check if edit is needed
if [ $editNeeded -eq 1 ]; then
	echo "[Warning] This image requires editing"
	newImagePath="$imagePath_needs_editing"
fi
# Take a screenshot!
screenshot $screenshotArgs -s --format=imageFormat $newImagePath
# Perform the end action
endAction
# Output paths of new and old image
echo
echo
echo "Success!"
echo "========="
echo "Original image path: " $imagePath.orig
echo "Final image path   : " $newImagePath
echo
exit
