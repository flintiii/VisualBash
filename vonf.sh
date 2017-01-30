#!/bin/bash
# pflint 2017-01-09 11:28:49 
# turns camera on or off
#
##
#* function help  - Help function for template basic help goes here
function help(){
clear;
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version; uroot #debug 
cat $0 | grep '^## ' | sed -e 's/##//'
# echo "This is the help function"
##                       *****DOCUMENTATION*****
## You get this when you put in the wrong number or type of arguments...
## The name of this program is vonf.sh, a tiddle based proposal generator.
## This is released under GPL I
## The syntax is:
##  - vonf.sh off  - Turns usb camera off - if unused. 
##  - vonf.sh on   - Turns usb camera off - if not blacklisted. 
##  - vonf.sh test - Tests if camera works. 
##  - vonf.sh stopcam - blacklists uvcvideo  
##  - vonf.sh startcam - un-blacklists uvcvideo   
##    in all of these, Output is delivered to the screen...
##      *** NOTE *** These commands need to be run as root!
##
## For structure information type "grep '^\#\*' vonf.sh"
##    :^)
## (C) P Flint, Barre Open Systems Institute Liscensed under GPLI
##
#          *****Documentation Loop ends here the rest is function******
#
} # Test: vonf.sh
#
#* function dummy - Rename and fill stuff in between braces
function dummy(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
uroot
} # Test:
#
#* function uroot - Checks to see if you are root
function uroot(){
# echo "Make sure only root can run script"
if [ "$(id -u)" != "0" ]; then
   echo "This script does not need to run as root but that's OK as you are not root" 1>&2
fi
} # Test:~flint/bin/chello.sh uroot
#
#
#* function stopcam - blacklists driver from /etc/modprobe.d
function stopcam(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
uroot
cp /etc/modprobe.d/blacklist_video_off.conf /etc/modprobe.d/blacklist.conf 
echo "Camera driver uvcvideo now blacklisted, reboot now" 
} # Test:
#
#* function startcam - unblaclists driver in /etc/modprobe.d
function startcam(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
cp /etc/modprobe.d/blacklist_video_on.conf /etc/modprobe.d/blacklist.conf 
echo "Camera driver uvcvideo now un-blacklisted, reboot now" 
uroot
} # Test:
#
# echo $1
case "$1" in
	  "on" )  echo "turn camera on"; modprobe uvcvideo ;;
 	 "off" )  echo "turn camera off"; modprobe -r uvcvideo ;;
     "stopcam" )  echo "turn camera off"; stopcam ;;
    "startcam" )  echo "turn camera off"; startcam ;;
 	"test" )  echo "testing camera camera";  cheese &;;
	     * ) echo "Signal number $1 is not processed"; help ;;
esac
# if $1 
# modprobe uvcvideo
# modprobe -r uvcvideo
# modprobe uvcvideo
# cheese


