 0000000000000000   000000000000000     0000        00    000000000000000    000000000000000    00           00    000000000000000
00000000000000000  00000000000000000  0000000       000  00000000000000000  00000000000000000   000         000   00000000000000000
000                000                000  000      000         000         000                  000       000    000
000                000                000   000     000         000          000                  000     000      000
000      0000000   0000000000000000   000    000    000         000           000000000000         000000000        000000000000
000      00000000  0000000000000000   000     000   000         000            000000000000          00000           000000000000
000           000  000                000      000  000         000                      000          000                      000
000           000  000                000       000 000         000                       000         000                       000
00000000000000000  00000000000000000  000        000000  00000000000000000  00000000000000000         000         00000000000000000
 0000000000000000   000000000000000    00         0000    000000000000000    000000000000000          000          000000000000000
  
####################################################################################################################################
####################################################################################################################################

Version: 0.5

GeniSys was created by the CEO of MadGodInc, MadGodNerevar.

MadGodNerevar proudly works for QuadraNet Systems as a Support Agent and tinkers with random ideas in his spare time, that is where the birth of GeniSys came in.

Due to the nature of the script this must be run from a Memory Stick\Flash drive, name it as you will, this will not work if it is stored on the desktop.

The purpose of this batch file is to run several scripts with the idea of a fresh setup/install of EPOS.
The Application made by the friendly development team from QuadraNet Systems.

Please note this MUST be run as an Administrator, i have tried to account for this which is why there is a shortcut version with the QuadraNet Systems Logo that is set to run as Admin.

This batch file runs a few things, first it will check for C:\Quadranet\EPOSv5, failing to find this
it shall create a new directory of the same name.

Once C:\Quadranet\EPOSv5 has been created it'll pull the files from the server defined by the user and
copy them straight into the directory that was created.

The EPOSv5 application that is copied over will be automatically started and the folder housing this will be opened,
When the folder is opened this will give the opportunity of creating a shortcut to send to the Desktop.

The installation continues with installing the QuadraNet Systems TeamViewer Host that is necessary for continued support.

Finally the batch file adds the famous AutoLogin Script to it, which means that most of the setup is as Automated as possible. 

Be wary that if a password is required for AutoLogin this MUST be inserted into the DefaultPassword Field between the quatation marks "". All that needs to be done is edit the GeniSys.bat file with a text editor, notepad, notepad++ etc... save it and then run.

GeniSys is a work in progress and will be improved as time passes, i am hoping to Automate as many of the processes as possible to provide swift resolutions and installs.
