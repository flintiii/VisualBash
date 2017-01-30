#!/bin/bash
# pflint Fri Sep 14 10:29:19 EDT 2012
# pflint Mon 05 Nov 2012 09:14:14 AM EST Added standard functions
# pflint Tue 27 Nov 2012 08:35:47 AM EST Added security variables\]
# pflint Mon 15 Apr 2013 09:00:27 AM EDT check for passwords
version="1.0"
#
# hold environment
export S=$PWD
#* move to the appropriate directory
# cd ??
#
#* check location of vital files and programs, sanity check
# ??
#
# Define files to be used
# uid="" ; if [ "$uid" == "" ]; then echo "Set user id!"; exit; fi
# passwd="" ; if [ "$passwd" == "" ]; then echo "Set user passwd!"; exit; fi
# ??
#
#* function help  - Help function for template basic help goes here
function help(){
clear;
echo "This is "$0"  "$version
cat $0 | grep '^## ' | sed -e 's/##//'
# echo "This is the help function"
##                       *****DOCUMENTATION*****
## You get this documentation when you put in the wrong number of arguments...
## The name of this program is template.sh, a collection of general purpose tools.
## for managing printing at the VDOL.  This is released under GPL I
## The syntax is:
##  - template.sh dummy tests the dummy function
##    Output is delivered to the screen...
##  - template.sh pause <message> displays message and with enter exits normally
##  - template.sh wait <n> <filename> where "n" is
##  - template.sh get <n> <message> where "n" is wait time,displays message
##    and exits normally
##  - template.sh get <n> <filename> where "n" is
##  - template.sh get all <n> where "n" is typically
##    Output is delivered to the directory you are in...
## For structure information type "grep '^\#\*' template.sh"
##    :^)
## (C) P Flint, Vermont Department of Labor Liscensed under GPLI
##
#          *****Documentation Loop ends here the rest is function******
#
} # Test: template.sh
#
#
#* function dummy - Dummy basic function template. ajm1Rename and fill stuff in between braces
function dummy(){
echo "This is the dummy function"
} # Test:
#
#*######################################STANDARD AND MAYBE USEFUL FUNCTIONS BELOW
#
#
#* function dir - this directory function is very specific as to what directory and what target
function dir(){
#debug echo $#"     "$var1"    "$var2"    "$var3"    "$var4"    "$ARGS
targ2=$(echo $var2 | tr '[:lower:]' '[:upper:]')
# echo $var2"   "$targ2
targ3=$(echo $var3 | tr '[:lower:]' '[:upper:]')
# echo $var3"   "$targ3
if [ "$var4" = "now"  ]; then cdate=$(echo $(date +%b\ %d)); else cdate=$(echo $var4 | tr '[:lower:]' '[:upper:]'); fi
echo $var4"   "$cdate
echo -n "This dir function is specific to the directory that "$targ2" files  in "
echo "LECS2:ADP/VSELIB/USRLIB2/AFP22/ filtered for "$targ2
case "$ARGS" in
   "4") echo "...additionally filtered for "$targ3" dated "$cdate; curl ftp://$uid:$passwd@159.105.80.205/ADP/VSELIB/USRLIB2/AFP22/ 2>/dev/null   | grep -i $var2 | grep -i $var3 | grep -i "$cdate" | cut -c 26- ;;
   "3") echo "...additionally filtered for "$targ3 ; curl ftp://$uid:$passwd@159.105.80.205/ADP/VSELIB/USRLIB2/AFP22/ 2>/dev/null   | grep -i $var2 | grep -i $var3 | grep -i "$cdate" | cut -c 26- ;;
   "2") echo "...and additionally filtered for "$var3; curl ftp://$uid:$passwd@159.105.80.205/ADP/VSELIB/USRLIB2/AFP22/ 2>/dev/null   | grep -i $targ2 | grep -i $var2 | cut -c 26- ;;
   "1") curl ftp://$uid:$passwd@159.105.80.205/ADP/VSELIB/USRLIB2/AFP22/ 2>/dev/null   | grep -i $targ2 | cut -c 26-;;
esac # end of choices
echo "finished"
} # Test: template.sh dir
#
#
# copy files to mainframe
#* function rename- Renames the PHASE file PHAOK or optionally the file name of your choice
function rename(){
echo "renaming "$oldname" to "$newname
pause "Are you ready?"
/usr/bin/curl -I "ftp://$uid:$passwd@159.105.80.205/ADP/VSELIB/USRLIB2/AFP22/" -Q "-RNFR $curname" -Q "-RNTO $newname" # rename from PHASE to PHAOK
} # Test:
#
#* function spause- A simple tarry...
function spause(){
   # -t sets time
   # read -t $pt -p "$*" ans
   read -p "Hit enter to continue..." ans
   echo $ans

}
#
#* function pause - Allows many ways to tarry...
function pause(){
#debug echo "Vairables in Pause are: "
#debug echo $#"     "$1"    "$ARGS
   # -t sets time
   # read -t $var3 -p "$*" ans
case "$ARGS" in
   "6") read -t $time -p "$prompt";;
   "5") read -p "$prompt";;
   "1") read;;
esac # end of choices
   # echo $ans
} # TESTS: template.sh pause; template.sh pause "Testing wait"; template.sh pause 3 "Testing 1,2,3";/manage_main
#
#
#* function listful-This function checks to make certian you have appropriate files
function listful(){
# echo "This is the listful function"
#debug echo $#"     "$1"    "$ARGS
if [ ! -e "$list" ] ; then
    clear
    echo "The path to ICCFLIST.TXT must be right for $0 to work..."
    echo ""${var2:0:$((${#var2}-3))}
    echo "Sadly, the file "$list" does not exist"
    read -p "Please change the current path \($list\): " -e list
    # echo "test it again"
    # ARGS="5"
    listful
else
    echo ""
fi # listful
} # Test: $0 listfull
#
#* function get  -  This downloads single ICCF files from specific libraries
function get()
{
echo "The file we are downloading from " $LIB" is: "$FILE
curl -s ftp://$uid:$passwd@159.105.80.225//ADP/DWN/ICCF/$LIB/$FILE -o $FILE".iccf."$LIB".txt"
# echo " is downloaded" |tee --append ../../sendjcl.log
ls -alt | grep $FILE | cut -c
26- #>> ../../sendjcl.log
} # end of get function
#
#* function cleanup-Cleanup function deletes all temporary files
function cleanup(){
echo "This is the cleanup function"
# Clean up stuff used in this function
# Remove buffers
rm iccf.first.half iccf.second.half iccflist$LIBR.txt $LIBR.iccf.column 2>/dev/null
# rm $1 # removes the target file...
# mv $1 ../../$1 # instead, moves the target file to ../../$1
# mv $1 ../../$1"_"$(date +%Y-%m-%d) # most severe, moves the target file to ../../$1
} # Test:
#
#* function camd  - Check and manuipulate days
function camd()
{
# if [ $($1 +%u) -ne "1" ]; then
# echo $(date --date=$1 +%u)
if [ $(date --date=$DATE +%u) -eq "1" ]; then
        echo "I suppose it is Monday";
        bin/2stap.sh $DATE                  # do today, Monday
        DATE=$(date --date=$DATE"-3day" +%m/%d/%Y ) # do Friday
    else
        echo "it is not Monday";
    fi # test for Mondayness...
} # end of cass- monday-monday
#
#* function fwatch - Watches the end of a file indefinitely
function fwatch(){
echo $#"     "$var2"    "$ARGS
 watch tail -20 $var2
} # Test: template.sh fwatch  var/log/messages
#
#* This downloads single files as in the listing
function get(){
echo "The file we are downloading from " $LIB" is: "$FILE
curl -s ftp://$uid:$passwd@159.105.80.225//ADP/DWN/ICCF/$LIB/$FILE -o $FILE".iccf."$LIB".txt"
} # Test: template.sh get
#
#* function cleanup - cleanup function deletes all temporary files
function cleanup(){
echo "This is the cleanup function"
echo $#"        "$ARGS
#* Clean up stuff used in this function
#* Remove buffers
rm iccf.first.half iccf.second.half iccflist$LIBR.txt $LIBR.iccf.column 2>/dev/null
# rm $1 # removes the bin/template.sh wait "..go on" 5target file...
# mv $1 ../../$1 # instead, moves the target file to ../../$1
# mv $1 ../../$1"_"$(date +%Y-%m-%d) # most severe, moves the target file to ../../$1
} # Test:
#
#*###################################### MAIN ENTRY POINT AND COMPOUND CASE
#
echo "template.sh v 0.2 starts"
#* Evaluator Routine
# Note the evaluator allows for many cases and error checking...
# ARGS=$#         # carries the number of args into the functions...
if [ "$#" -eq "1" ] && [ "$1" = "dummy"   ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "spause"  ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "pause"   ]; then ARGS="1"; fi
if [ "$#" -eq "2" ] && [ "$1" = "pause"   ]; then ARGS="5"; fi
if [ "$#" -eq "3" ] && [ "$1" = "pause"   ]; then ARGS="6"; fi
if [ "$#" -eq "2" ] && [ "$1" = "fwatch"  ]; then ARGS="2"; fi
if [ "$#" -eq "3" ] && [ "$1" = "get"     ]; then ARGS="6"; fi
if [ "$#" -eq "4" ] && [ "$1" = "dir"     ]; then ARGS="4"; fi
if [ "$#" -eq "3" ] && [ "$1" = "dir"     ]; then ARGS="3"; fi
if [ "$#" -eq "2" ] && [ "$1" = "dir"     ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dir"     ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "tlog"    ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "cleanup" ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "listful" ]; then ARGS="9"; fi
if [ "$#" -eq "3" ] && [ "$1" = "wait"    ]; then ARGS="6"; fi
if [ "$#" -eq "1" ] && [ "$1" = "help"    ]; then ARGS="9"; fi
# this tests the evaluator...
#debug echo $#"     "$1"    "$2"    "$3"    "$ARGS #debug
# typical cases, be careful to make your own...
case "$ARGS" in
    "0") clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;; # got nothing, display help and go
    "1") $1 ;;                                              	# run the command
    "2") var2=$2;  $1 ;;                                    	# run the command with an argument
    "3") var3=$3; var2=$2;  $1 ;;                           	# run the command with two arguments
    "4") var4=$4; var3=$3; var2=$2;  $1 ;;                      # run the command with three arguments
    "5") prompt=$2; $1 ;;				    	# run the command with a different argument
    "6") time=$3; prompt=$2;  $1 ;;				# run the command with two different arguments
    "7") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
    "8") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
    "9") clear; echo $ARGS" Your function here" ;;		# Spare for capacity
      *) clear; cat $0 | grep '^## '| sed -e 's/##//'; exit 1;;  # Anything else run help and exit...
esac # End main loop. To TEST:
#
# echo " ";
echo "template.sh stops"
#  That's all folks!!
# Junk shop
#     if [ "$#" -eq "3" ] && [ "$1" = "get" ] && [ "$2" = "all"  ];  then ARGS="7"; fi
#    "2") secs=$2;  while read line ; do $1; done;;             # read from a file and process
#     *) clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;;
#* restore environment
cd $S

