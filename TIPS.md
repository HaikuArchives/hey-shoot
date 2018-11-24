
Helpful Tips for hey-shoot Scripts
===================================
## General Bash Scripting ##
A really useful tool for checking bash code:
https://www.shellcheck.net/

1. Don't put spaces around "=".
2. Put spaces around "[" and "]". Bash is really weird :/
3. Put quotes around ALL paths that uses bash variables.


## hey Scripting ##
1. Use `hey [APP] getsuites` to get the general properties of the app.
   `hey [APP] getsuites of Window 0` gets the scripting properties of specific windows.
2. Use `hey [APP] 'message-value'` to perform actions on the app.
   You may have to look at the app's source code (usually the header files)
   to find these constants.
3. Setting values of checkboxes and buttons to 1 **does not click the buttons**.
   If you really want to click things on the app, send messages to the app.
   

## Specific to hey-shoot ##
1. Try to use the `waitfor [APP]` command wherever possible.
   If this is not possible, I recommend playing around with the "delay" function.
   Some systems run faster than others, so you may want to change 0.5 to something bigger.
   The delay makes sure that Screenshot doesn't take a screenshot before the app loads.
2. Keep in mind that some apps require a revert to default settings before screenshot.
   In this case, you should:
     * Backup your settings file to `$tempDir`.
     * Revert settings of the app. Close app. The app's "settings" file should updated.
     * Copy this settings file to the $workfileDir directory. Rename to "[app].default-settings".
   Now, you should add some commands that copy the user's settings file to `$tempDir`,
   copy the default settings to the settings directory, take a screenshot of the app,
   and restore the user's settings into the settings directory.
   Please also remove the user settings from `$tempDir`.
   
