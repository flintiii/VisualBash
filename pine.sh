#!/bin/bash
# pflint Wed 29 Jan 2014 09:29:41 AM EST 
# 
version="1.7"
#
# hold environment
export S=$PWD
#* move to the appropriate directorygrep '^\#\*' pine.sh
# cd ??
#
#* check location of vital files and programs, sanity check
#* check location of vital files and programs, sanity check
for prog in curl gawk banana
do
# echo $prog
isit=$(which $prog)
echo $isit
if [ ! -f "$isit" ]
then
    echo "the file $prog is not on system"
    exit 0
fi
done
# runs ballisticly
#
# Define files to be used
# 
# qualify user
# uid="" ; if [ "$uid" == "" ]; then echo "Set user id!"; exit; fi
# passwd="" ; if [ "$passwd" == "" ]; then echo "Set user passwd!"; exit; fi
# ??
# uroot
#
#* function help  - Help function for template basic help goes here
function help(){
clear;
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug 
cat $0 | grep '^## ' | sed -e 's/##//'
# echo "This is the help function"
##                       *****DOCUMENTATION*****
## You get this when you put in the wrong number or type of arguments...
## The name of this program is pine.sh, just a simple gizmo to get around.
## The difficulty of having the dove imap daemon and pine fight. 
## This is released under GPL I
## The syntax is:
##  - pine.sh status - Lets you know the status of dovecot imapd
##  - pine.sh off - Turns on imapd makes pine intermittent, 
##  - pine.sh on - Allows pine to function, turns off imapd
##    in all of these, Output is delivered to the screen...
##      *** NOTE *** This program must be run as root!
##
## For structure information type "grep '^\#\*' pine.sh"
##    :^)
## (C) P Flint, Barre Open Systems Institute Liscensed under GPLI
##
#          *****Documentation Loop ends here the rest is function******
#
} # Test: pine.sh
#
#* function dummy - Rename and fill stuff in between braces
function dummy(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
uroot
} # Test:
#
#* function status - Gives a status indication of the current status...
function status(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
sudo /etc/init.d/dovecot status
} # Test: ~flint/bin/pine.sh status 
#
#* function use - shuts down dovecot starts pine and then starts up dovecot
function use(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
# starts pine w/o dovecot
sudo /etc/init.d/dovecot stop
pine
# alpine
sudo /etc/init.d/dovecot start
uroot
} # Test:
#
#* function off - turns off imapd, and starts up pine...
function off(){
# uroot
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
echo "This stops dovecot"
sudo /etc/init.d/dovecot stop
# alpine
} # Test: pine.sh off
#
#* function on - on allows pine to function, turns off imapd
function on(){
# uroot
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
echo "This starts dovecot"
sudo /etc/init.d/dovecot start
} # Test:~flint/bin/pine.sh on
#
#* function uroot - Checks to see if you are root
function uroot(){
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
} # Test:~flint/bin/pine.sh uroot
#
#
#*###################################### MAIN ENTRY POINT AND COMPOUND CASE
#
# echo "pine.sh v"$version" starts"
#* Evaluator Routine
# Note the evaluator allows for many cases and error checking...
# ARGS=$#         # carries the number of args into the functions...
if [ "$#" -eq "1" ] && [ "$1" = "status"  ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "use"     ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "off"     ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "on"      ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dummy"   ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "uroot"   ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "help"    ]; then ARGS="9"; fi
# this tests the evaluator...
#debug echo $#"     "$1"    "$2"    "$3"    "$ARGS  
# typical cases, be careful to make your own...
case "$ARGS" in
    "0") clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;; # got nothing, display help and go
    "1") $1 ;;                                              	# run the command
    "2") var2=$2;  $1 ;;                                    	# run the command with an argument
    "3") var3=$3; var2=$2;  $1 ;;                           	# run the command with two arguments
    "4") var4=$4; var3=$3; var2=$2;  $1 ;;                      # run the command with three arguments
    "5") prompt=$2; $1 ;;				    	# run the command with a different argument
    "6") time=$3; prompt=$2;  $1 ;;				# run the command with two different arguments
    "7") defvbl; $1 ;;						# run the command and default variables
    "8") var2=$2;  $1 ;;                                 	# run the command and settle variables
    "9") var3=$3; var2=$2;  $1 ;;                               # run the command and settle variables
      *) clear; cat $0 | grep '^## '| sed -e 's/##//'; exit 1;; # Anything else run help and exit...
esac # End main loop. To TEST:
#
# echo " ";
echo "On "$(date +%F) $0" version "$version" stops"
#  That's all folks!!
#
#* restore environment
cd $S
