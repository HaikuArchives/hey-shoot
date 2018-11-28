#!/bin/bash

## Developed by BachToTheFuture
## for GCI 2018

## Basic information ##
# targetName	: This is the name of the app you are going to open
# imageName 	: This is the name of the image that you will replace
#				| ** Extensions required **
# imageSubPath	: The parent folder of the image

targetName="DiskProbe"
imageName="diskprobe.png"
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
	# Inspect AboutSystem like the original picture
	"$targetName" /boot/system/apps/AboutSystem &
	waitfor "$targetName"
	# Set the window size to a size much like the original picture.
	hey -o "$targetName" set Frame of Window 1 to "BRect(200,100,800,100)"
}

## Actions after screenshots ##
# Close the apps opened by this script.
function endAction {
	hey -o "$targetName" quit
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

# Perform the end action
endAction

# Output paths of new and old image
echo
echo "Original: $imagePath.orig"
echo "New     : $newImagePath"
echo
exit
