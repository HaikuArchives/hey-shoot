# hey-shoot
### Created by BachToTheFuture for the 2018 GCI.

`hey-shoot` is a bash script for automating the retake of the screenshots
shown in Haiku's UserGuide.

`hey-shoot` script is written for each app with a picture in the UserGuide.
The script opens the app and will rearrange and perform actions on the app
based on the user's preferences. The script will then take a screenshot of the app.
This screenshot replaces the corresponding image of the app in UserGuide's `image` directory.

#### Usage
Copy the `hey-shoot-template.sh`, and replace "template" with the name of the image
that you want to replace in UserGuide's `image` directory.

Then run `hey-shoot-[imagename].sh [directory-to-userguide-lang-abbrev]`.
