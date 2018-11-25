
Helpful Tips for hey-shoot Scripts
===================================


## General Bash Scripting ##

A really useful tool for checking bash code:
https://www.shellcheck.net/
Before running your script, test it with ShellCheck. It'll point out all the
(potential) issues in your code.


## hey Scripting ##

1. As an introduction, see the article "Scripting the GUI with 'hey'" at
   https://v.gd/pQCaWW

2. `hey [APP] getsuites` shows the general scripting properties of the app.
   `hey [APP] getsuites of Window 0` gets the properties of a specific window.

3. Setting values of checkboxes and buttons to "1" **does not perfom the action
   of the button/checkbox**.
   If you really want to make things happen, send messages to the app.

4. `hey [APP] 'message-value'` performs actions by sending a BMessage.
   You'll have to look at the app's source code to find the constants that are
   used in an app's MessageReceived() hook.


## Specific to hey-shoot ##

1. Try to use the `waitfor [APP]` command wherever possible to makes sure that
   the screenshot isn't taken before the app loads and displays its window.
   If `waitfor` can't be used, use the "delay" function instead.
   Some systems run faster than others, so you may want to change 0.5 to
   something bigger.

2. Keep in mind that some apps may be differently configured on a users system
   and may require a revert to default settings before the screenshot.
   In this case, you'll have to provide a default settings file named
   "[APP].default-settings" in the `workfile` folder.

   In the hey-shoot script you then:
    * Backup the app's settings file(s) to `$tempDir`.
    * Copy the "[APP].default-settings" from `$workfileDir` to the settings
      folder and rename it back to the file name the app expects.
    * Do your hey scripting and take your screenshot.
    * Move the backed up file from `$tempDir` back to the setting folder.
