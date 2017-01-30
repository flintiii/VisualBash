#!/bin/bash
# pflint Fri Sep 14 10:29:19 EDT 2012
# pflint Mon 05 Nov 2012 09:14:14 AM EST Added standard functions
# pflint Tue 27 Nov 2012 08:35:47 AM EST Added security variables
# age.sh is based upon these conventions:
# 1. All backup files are gzipped files named by their slice.
# 2. These are contained in directories typically about 9 GB
# 3. Backup files are named "year-mm-dd-backup"
# 4. Monthly pulls from these root files are named in this pattern "mon-year.bu"
# 6. Monthly pull directories should contain three directories each;
#	a. One from the beginning of the month
#	b. One from the middle of the month
#	c. One from the end of the month
# 5. Yearly collections are in directories "year"
# Thu 29 Nov 2012 08:33:51 AM EST subroutine name change
# 
version="1.1"
#
# hold environment
export S=$PWD
#* move to the appropriate directorygrep '^\#\*' age.sh
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
## The name of this program is age.sh, a collection oftools for aging out.
## Disaster Recovery and Development files on Gompers at the Burlington VDOL 
## office.  This is released under GPL I
## The syntax is:
##  - age.sh status details what the current situation is
##  - age.sh stmnth <1-12> details a current or default month
##    in bothe of these, Output is delivered to the screen...
##  - age.sh mvmnth [1-12] [test/make] does a monthly cleanup,  
##    based upon the criteria, optionally selects month and test. 
##    Output actions are delivered to the screen...
##  - age.sh mkmnth [test/make] [1-12] makes a current month   
##    directory, optionally selects month, 
##  - age.sh domnth [1-12] [test] makes month directory and 
##    moves in the specified three directories.
##  - age.sh mkyr [year] makes a year directory, optionally 
##    selects year, moves all months in, and exits normally.
##  - age.sh cleanup [test] optionally a rehersal
##    Output is delivered to the directory you are in...
##  - age.sh get <n> <filename> where "n" is
##  - age.sh dummy tests the dummy function
##    Output is delivered to the screen...
## For structure information type "grep '^\#\*' age.sh"
##    :^)
## (C) P Flint, Vermont Department of Labor Liscensed under GPLI
##
#          *****Documentation Loop ends here the rest is function******
#
} # Test: age.sh
#
#* function dummy - Rename and fill stuff in between braces
function dummy(){
echo "This is the dummy function"
} # Test:
#
#
#* function status - Gives a status indication of the backup area...
function status(){
echo "This is the status function"
for i in {1..12}
do 
  # echo $i
  valf=$(printf "%.2d" "$i")
  echo "Directories unfiled for "$(year=$(date +%y) ; echo $(date --date="$valf/1/$year" +%B|tr [:upper:] [:lower:]))" are:"
  # ls -1 | grep backup |grep "\-$valf\-" 
  ls -1 | grep backup | grep -e "\-$valf\-" | grep -v "\-$valf\-backup"
  spause
done
} # Test:
#
#* function stmnth - Gives a status indication of the backup area for a paticular month...
function stmnth(){
#debug echo "This is the stmnth function"
echo "The current location is: "$PWD
month=$(printf "%.2d" "$dmonth")
echo "Directories unfiled for "$(year=$(date +%y) ; echo $(date --date="$month/1/$year" +%B|tr [:upper:] [:lower:]))" are:"
# ls -1 | grep backup | grep -e "\-$month\-" | grep -v "\-$month\-backup"
du -h --max-depth=1 2>/dev/null | grep backup | grep -e "\-$month\-" | grep -v "\-$month\-backup"
spause
echo "Directories in "$PWD"/"$dname" are:"
du -h --max-depth=1 2>/dev/null $dname
} # Test: age.sh stdmnth 11
#
#* function defvbl - default variables for no arguments
function defvbl(){
#debug echo "This is the defvbl function" #debug 
#debug echo $#"     "$var1"     "$var2"     "$var3"    "$ARGS   #debug 
dmonth=$(date +%m); # month is the current month
dname=$(year=$(date +%Y) ; echo $(date  +%b|tr [:upper:] [:lower:]))"-"$(date +%Y)".bu" # current
echo "The month is: "$dmonth
echo "the backup location is: "$dname
} # Test:
#
#
#* function waiw - figures out which argument is which...
function waiw(){
#debug echo $#"     "$var1"     "$var2"     "$var3"    "$ARGS   
#debug echo "This is the waiw function"
if [ "$var2" -eq "$var2" ] 2>/dev/null; then
  echo "The first variable is a number so it is the month"; dmonth=$var2; dtest=$var3
else
  echo " the first variable is not a number so it is the test directive"; dmonth=$var3; dtest=$var2
fi
#
if [[ $dmonth -lt 1 || $dmonth -gt 12 ]]; then echo "out of range using default"; dmonth=$(date +%m); fi
month=$dmonth
dname=$(year=$(date +%Y) ; echo $(date --date="$month/1/$year" +%b|tr [:upper:] [:lower:]))"-"$(date +%Y)".bu"
echo "The month is: "$dmonth
echo "The test directive: "$dtest
echo "the backup location is: "$dname
} # Test: age.sh waiw
#
#* function domnth - Rename and fill stuff in between braces
function domnth(){
echo "This is the domnth function"
#debug echo $#"     "$var1"     "$var2"    "$var3"    "$ARGS 

} # Test:
#
#
#* function mkmnth - makes a directory for the particular month
function mkmnth(){
if [ "$(echo "$dtest" | tr [:lower:] [:upper:])" == "TEST" ];
then
	echo "If this were not a test I would have made a directory with the name "$dname 
	# ls -alt 
	exit 1  
fi
echo "Just made a directory called "$dname" see?"
mkdir $dname
ls -alt $dname
} # Test:

#
#* function mvmnth - Select directories to keedefvblp and move them. Note TEST function
function mvmnth(){
echo "This is the mvmnth function"
#
month=$(printf "%.2d" "$dmonth")
echo "The month is mvmnth is "$month
half=$(( $(ls -1 | grep backup | grep "\-$month\-" | wc -l)/2 ))
begdir=$(ls -1 | grep backup | grep "\-$month\-" | head -1)
middir=$(ls -1 | grep backup | grep "\-$month\-" | sed $half'q;d')
enddir=$(ls -1 | grep backup | grep "\-$month\-" | tail -1)
if [ "$(echo $dtest | tr [:lower:] [:upper:])" == "TEST" ];
then
	echo "I was only kidding! of the $(ls -1 | grep backup | grep "\-$month\-"|wc -l) files available"
	echo "here are the directories we would have moved." 
	echo -e "First of the month: "\\t$begdir
	echo -e "Middle of the month: "\\t$middir
	echo -e "Last of the month: "\\t$enddir
	exit 1  
fi
echo "I am not kidding! here are the directories we are about to move:" 
echo -e "First of the month: "\\t$begdir
echo -e "Middle of the month: "\\t$middir
echo -e "Last of the month: "\\t$enddir
# ARGS="5"; prompt="Ready to do this?" ;pause 
spause
for save in $begdir $middir $enddir
do
 dest=$dname"/"$save
 echo "moving "$save" to "$dest
 mv $save $dest #debug 
done 
} # Test: age.sh mvmnth
#
#
#* function cleanup  - Cleanup function deletes all the day directories in current directory
function cleanup(){
#debug echo "This is the clean up function"
#debug echo $#"     "$var1"     "$var2"     "$var3"    "$ARGS   
# Clean up stuff that remains in the current directory note TEST function
valf=$(printf "%.2d" "$dmonth"); #debug echo $dmonth $month $valf
dirno=$(ls -1 | grep backup | grep -e "\-$valf\-" | grep -v "\-$valf\-backup" | wc -l)
#
if [ "$(echo $dtest | tr [:lower:] [:upper:])" == "TEST" ];
then
	echo "I was only kidding! We would have erased these $dirno directories:" 
	du -h --max-depth=1 2>/dev/null | grep backup | grep -e "\-$valf\-" | grep -v "\-$valf\-backup" 
	exit 1  
fi
echo "we are cleaning these up now:"
# ls -1 | grep backup | grep -e "\-$month\-" | grep -v "\-$valf\-backup"
du -h --max-depth=1 2>/dev/null | grep backup | grep -e "\-$valf\-" | grep -v "\-$valf\-backup" 
spause
echo "Deleting the following:"
ls -1 | grep backup | grep -e "\-$valf\-" | grep -v "\-$valf\-backup"
ls -1 | grep backup | grep -e "\-$valf\-" | grep -v "\-$valf\-backup" |xargs -I xxx rm -rf xxx
} # Test: age.sh cleanup
#
# 
#*######################################STANDARD AND MAYBE USEFUL FUNCTIONS BELOW
#
#
#
#* function spause   - A simple tarry...
function spause(){
   # -t sets time
   # read -t $pt -p "$*" ans
   read -p "Hit enter to continue..." ans
   echo $ans
}
#
#* function pause    - Allows many ways to tarry...
function pause(){
#debug echo "Vairables in Pause are: "
#debug echo $#"     "$-e 1"    "$ARGS 
   # -t sets time
   # read -t $var3 -p "$*" ans$(ls -1 | grep backup |wc -l)
case "$ARGS" in
   "6") read -t $time -p "$prompt";;
   "5") read -p "$prompt";;
   "1") read;;
esac # end of choices
   # echo $ans
} # TESTS: age.sh pause; age.sh pause "Testing wait"; age.sh pause 3 "Testing 1,2,3";
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
#debug echo $#"     "$var2"    "$ARGS
 watch tail -20 $var2
} # Test: age.sh fwatch  var/log/messages
#
#
#*###################################### MAIN ENTRY POINT AND COMPOUND CASE
#
echo "age.sh v 0.2 starts"
#* Evaluator Routine
# Note the evaluator allows for many cases and error checking...
# ARGS=$#         # carries the number of args into the functions...
if [ "$#" -eq "1" ] && [ "$1" = "status"  ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "domnth"  ]; then ARGS="7"; fi
if [ "$#" -eq "2" ] && [ "$1" = "domnth"  ]; then ARGS="8"; fi
if [ "$#" -eq "3" ] && [ "$1" = "domnth"  ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "mkmnth"  ]; then ARGS="7"; fi
if [ "$#" -eq "2" ] && [ "$1" = "mkmnth"  ]; then ARGS="8"; fi
if [ "$#" -eq "3" ] && [ "$1" = "mkmnth"  ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "mvmnth"  ]; then ARGS="7"; fi
if [ "$#" -eq "2" ] && [ "$1" = "mvmnth"  ]; then ARGS="8"; fi
if [ "$#" -eq "3" ] && [ "$1" = "mvmnth"  ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "stmnth"  ]; then ARGS="7"; fi
if [ "$#" -eq "2" ] && [ "$1" = "stmnth"  ]; then ARGS="8"; fi
if [ "$#" -eq "1" ] && [ "$1" = "spause"  ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "pause"   ]; then ARGS="1"; fi
if [ "$#" -eq "2" ] && [ "$1" = "pause"   ]; then ARGS="5"; fi
if [ "$#" -eq "3" ] && [ "$1" = "pause"   ]; then ARGS="6"; fi
if [ "$#" -eq "2" ] && [ "$1" = "waiw"    ]; then ARGS="2"; fi
if [ "$#" -eq "3" ] && [ "$1" = "waiw"    ]; then ARGS="3"; fi
if [ "$#" -eq "4" ] && [ "$1" = "dir"     ]; then ARGS="4"; fi
if [ "$#" -eq "3" ] && [ "$1" = "dir"     ]; then ARGS="3"; fi
if [ "$#" -eq "2" ] && [ "$1" = "dir"     ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dir"     ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "cleanup" ]; then ARGS="7"; fi
if [ "$#" -eq "2" ] && [ "$1" = "cleanup" ]; then ARGS="8"; fi
if [ "$#" -eq "3" ] && [ "$1" = "cleanup" ]; then ARGS="9"; fi
if [ "$#" -eq "1" ] && [ "$1" = "defvbl"  ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dummy"   ]; then ARGS="1"; fi
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
    "8") var2=$2;  waiw; $1 ;;                                  # run the command and settle variables
    "9") var3=$3; var2=$2; waiw;  $1 ;;                         # run the command and settle variables
      *) clear; cat $0 | grep '^## '| sed -e 's/##//'; exit 1;; # Anything else run help and exit...
esac # End main loop. To TEST:
#
# echo " ";
echo "age.sh stops"
#  That's all folks!!
# Junk shop
#     if [ "$#" -eq "3" ] && [ "$1" = "get" ] && [ "$2" = "all"  ];  then ARGS="7"; fi
#    "2") secs=$2;  while read line ; do $1; done;;             # read from a file and process
#     *) clear; cat $0 | grep '^## ' | sed -e 's/##//'; exit 1;;
#* restore environment
cd $S
