#!/bin/bash
# pflint Fri 30 Jan 2015 04:04:36 PM EST 
# setup bug worked   
# 
# Grant Generator
version="0.09"
#
#
#* function help  - Help function for template basic help goes here
function help(){
clear;
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version; uroot #debug 
cat $0 | grep '^## ' | sed -e 's/##//'
# echo "This is the help function"
##                       *****DOCUMENTATION*****
## You get this when you put in the wrong number or type of arguments...
## The name of this program is chello.sh, a tiddle based proposal generator.
## This is released under GPL I
## The syntax is:
##  - chello.sh sett <Tiddle URL> <UID> <PASS> - 
##    sets the name of the tiddlewiki you want to work on 
##  - chello.sh showt - shows  the name of the 
##    tiddlewiki you are currently working on 
##  - chello.sh maket <PROJNAME> - makes a <PROJNAME>  
##  - chello.sh remt  <PROJNAME> - removes a <PROJNAME>
##  - chello.sh settt <TITLE> - sets title in tiddle 
##  - chello.sh setst <STITLE> - sets sub-title in tiddle
##  - chello.sh overview  - generates and overview, sets it as default
##  - chello.sh dlt - downloads relevant tiddles
##  - chello.sh dtp - downloads default tiddler
##    in all of these, Output is delivered to the screen...
##      *** NOTE *** This program need not be run as root!
##
## For structure information type "grep '^\#\*' chello.sh"
##    :^)
## (C) P Flint, Barre Open Systems Institute Liscensed under GPLI
##
#          *****Documentation Loop ends here the rest is function******
#
} # Test: chello.sh
# next lines run ballisticly
#* hold environment
S=$PWD
# echo "This is the path "$S
# debug
#
# Define files to be used
#* function ch4ps - checks and reports on what you need.
function ch4ps(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
uroot
#* check location of vital files and programs, sanity check
rm -rf need > /dev/null
for prog in curl expect cadaver xmlstarlet git # debug banana
do
	# echo $prog
	isit=$(which $prog)
	# echo $isit 
	if [ ! -f "$isit" ];
	then
	    echo $prog >> need
	    #debug echo "Type \"sudo apt-get install $prog\" to fix this."
	    #debug spause
	    # exit 0
	fi
done
clear
echo "Welcome to $0!"
echo "Missing programs:"
	if [ -f need ];
	then
	   echo "    This program needs the following program(s) to be installed on this system."
	   cat need |while read line; do echo -e \\t" - " $line; done
	   echo "    If you want them installed please logon as root (sudo $0) and they will install"
	   exit 0 # breaks you out of loop...
	fi
#
echo "end of check"
} # Test:
#
#
#* function instg - # installs extra software if you are root, installs all the good stuff
function instg(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
if [ "$(id -u)" = "0" ] && [ -f need ]; then
   echo "You are root and you are about to install the following:" 1>&2
   cat need |while read line; do echo -e \\t" - " $line; done
   read -p "Hit enter to continue and install..." an
   #debug
   cat need |while read line; do apt-get install $line; done
   #debug cat need |while read line; do echo -e \\t" - " $line; done
fi
rm -rf need
#debug exit 0 # breaks you out of loop...
} # Test:
# 
# qualify user
# uid="" ; if [ "$uid" == "" ]; then echo "Set user id!"; exit; fi
# passwd="" ; if [ "$passwd" == "" ]; then echo "Set user passwd!"; exit; fi
# echo "Check if you are root"
# uroot()
# exit
#
# next lines run ballisticly
#debug 
instg # installs extra software if you are root
ch4ps # checks and reports on what you need.
# above runs ballisticly
#
#* function dummy - Rename and fill stuff in between braces
function dummy(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
uroot
} # Test:
#
#
#* function sett - sets the name and logon for tiddlewiki you want to work on
function sett(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
rm -rf ss
tiddleurl=$var2;uid=$var3;pass=$var4
#
echo -e " TiddleURL is\t"$tiddleurl 
echo -e " UID is \t"$uid
echo -e " PASS is \t"$pass
#
touch ss
echo $tiddleurl >> ss
echo $uid >> ss
echo $pass  >> ss
#
spause
} # Test: ./chello.sh sett one two three
#
#
#* function showt - shows the name for tiddlewiki you are currently working on
function showt(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
IFS=$'\n' ss=($(cat ss))
# [[ ${ss[1]} = $name ]] && echo "${a[$i]}"
tiddleurl=${ss[0]};
uid=${ss[1]};
pass=${ss[2]}
proj=${ss[3]}
#
echo -e " TiddleURL is\t"$tiddleurl 
echo -e " UID is \t"$uid
echo -e " PASS is \t"$pass
echo -e " PROJECT is \t"$proj
#
#debug spause
} # Test: ./chello.sh showt
#
#* function maket <PROJNAME> - makes a <PROJNAME> in the current tiddlewiki
function maket(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
#
showt > /dev/null
#debug spause
# packs expect and sends it out...
# 
# From this line to EOF is the code to export
# note slash escapes (\\)
read -d '' String <<"EOF"
#!/usr/bin/expect -f
set tiddleurl [lindex $argv 0]
set user      [lindex $argv 1]
set pass      [lindex $argv 2]
set proj      [lindex $argv 3]
# puts "Argument data:\n";
# puts "user: $user";
# puts "pass: $pass";
# puts "proj: $proj";
# puts "tiddleurl: $tiddleurl";
# check...
if { $user == "" || $pass == "" || $tiddleurl == "" || $proj == "" }  {
  puts "Usage: <user> <pass> <tiddleurl> <proj> n"
  exit 1
}
spawn /usr/bin/cadaver http://$tiddleurl/
expect "Username:"
send "$user\\n"
expect "Password:"
send "$pass\\n"
expect "dav:"
send "copy ZiddlyWiki $proj\\n"
expect "dav:"
send "quit\\n"
EOF
echo "this is the project "$var2
echo $var2 >> ss
echo "$String" > doit.exp
chmod +x doit.exp
# debug 
./doit.exp $tiddleurl $uid $pass $var2 | grep succeeded
#debug  > /dev/null
rm -rf doit.exp
#
} # Test: ./chello.sh maket banana
#
#* function remt <PROJNAME> - removes a <PROJNAME> in the current tiddlewiki
function remt(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
#
showt > /dev/null
#debug spause
# packs expect and sends it out...
# 
# From this line to EOF is the code to export
# note slash escapes (\\)
read -d '' String <<"EOF"
#!/usr/bin/expect -f
set tiddleurl [lindex $argv 0]
set user      [lindex $argv 1]
set pass      [lindex $argv 2]
set proj      [lindex $argv 3]
spawn /usr/bin/cadaver http://$tiddleurl/
expect "Username:"
send "$user\\n"
expect "Password:"
send "$pass\\n"
expect "dav:"
send "rmcol $proj\\n"
expect "dav:"
send "quit\\n"
EOF
# echo "this is the project "$var2
echo "$String" > doit.exp
chmod +x doit.exp
# debug 
./doit.exp $tiddleurl $uid $pass $var2 | grep succeeded
#debug  > /dev/null
#debug 
#debug 
rm -rf doit.exp
#
# remove the project name from secret squirrel fle

} # Test:
#
#
#* function settt - sets the name of the title tiddle 
function settt(){
# curl -T banana.title http://the:end@docbox.flint.com:1980/banana/tiddlers/SiteTitle
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
showt > /dev/null
echo $var2 > proj.title
curl -T proj.title http://$uid:$pass@$tiddleurl/$proj/tiddlers/SiteTitle
rc=$?; if [[ $rc != 0 ]]; then echo "error"; exit $rc; fi
echo $rc; 
spause
} # Test:
#
#* function setst - sets the name of the sub-title tiddle 
function setst(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
# curl -T banana.title http://the:end@docbox.flint.com:1980/banana/tiddlers/SiteTitle
showt > /dev/null
echo $var2 > proj.stitle
curl -T proj.stitle http://$uid:$pass@$tiddleurl/$proj/tiddlers/SiteSubtitle
rc=$?; if [[ $rc != 0 ]]; then echo "error"; exit $rc; fi
echo $rc; 
spause
} # Test:
#
#
#* function mktdl - creates an indivitual tiddle 
function mktdl(){
#debug 
showt > /dev/null
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
tiddle=$var2
echo "Making "$tiddle
echo $tiddle > $proj.$tiddle
curl -T proj.$tiddle http://$uid:$pass@$tiddleurl/$proj/tiddlers/$tiddle
rc=$?; if [[ $rc == 0 ]]; then echo "tiddle "$tiddle" made."; exit $rc; fi
echo $rc; 
spause
} # Test:
#
#* function popgp - populates the grant proposal 
function popgp(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
showt # > /dev/null
#debug spause
for tiddle in TitlePage Summary Introducion FundingSources ProblemNeed Methods Reports Future Budget
do
	echo "making "$tiddle
	echo $tiddle > $proj.$tiddle
	curl -T $proj.$tiddle http://$uid:$pass@$tiddleurl/$proj/tiddlers/$tiddle
done
#debug spause
} # Test: chello.sh popgp
#
#* function overview - creates the overview tiddle and populates it
function overview(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
showt > /dev/null
#
popgp #make categories
#
# make DefaultTiddlers file...
tiddle=DefaultTiddlers
ttopic=overview
echo "making "$ttopic
rm -rf $proj.$tiddle
echo "[["overview"]]" >> $proj.$tiddle
curl -T $proj.$tiddle http://$uid:$pass@$tiddleurl/$proj/tiddlers/$tiddle
echo "OK uploaded"
rc=$?; if [[ $rc == 0 ]]; then echo "tiddle "$tiddle" made."; fi
echo $rc; 
# spause
#
# make the overview file
tiddle=overview
echo "Starting to make "$proj.$tiddle
rm -rf $proj.$tiddle
for ttopic in TitlePage Summary Introducion FundingSources ProblemNeed Methods Reports Future Budget
do
	echo "making "$ttopic
	echo "#  [["$ttopic"]]" >> $proj.$tiddle
done
#
echo "Uploading "$proj.$tiddle
curl -T $proj.$tiddle http://$uid:$pass@$tiddleurl/$proj/tiddlers/$tiddle
rc=$?; if [[ $rc == 0 ]]; then echo "tiddle "$tiddle" made."; exit $rc; fi
echo $rc; 
# echo "Uploaded "$proj.$tiddle
echo "Erasing all files begining with "$proj"."
echo "This includes: "
ls -alt $proj.*
spause
rm -rf $proj.*
# echo $tiddle
#
} # Test: chello.sh
#
#* function dlt - Download relevant tiddles
function dlt(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
spause
read -d '' String <<"EOF"
#!/usr/bin/expect -f
set tiddleurl [lindex $argv 0]
set user      [lindex $argv 1]
set pass      [lindex $argv 2]
set proj      [lindex $argv 3]
spawn /usr/bin/cadaver http://$tiddleurl/
expect "Username:"
send "$user\\n"
expect "Password:"
send "$pass\\n"
expect "dav:"
send "cd $proj\\n"
expect "dav:"
send "cd tiddlers\\n"
expect "dav:"
send "ls\\n"
expect "dav:"
send "quit\\n"
EOF
echo "this is the project "$proj
echo "$String" > doit.exp
chmod +x doit.exp
# debug 
./doit.exp $tiddleurl $uid $pass $proj | grep "^        " > slug.dir
sed 's/^        //g' slug.dir | # Pipe throught filters
     grep -vi "Basic_Editing" | # 
     grep -vi "FormattingInstructions" > $proj.dir 
cat $proj.dir
#| grep succeeded
#debug  > /dev/null
#
#debug 
spause
} # Test:
#
#* function dlr - Rename and fill stuff in between braces
function dlr(){
echo "This is the \""$FUNCNAME"\" function in "$0" version "$version #debug
#debug 
showt > /dev/null
# debug
n=1
curl -s http://$uid:$pass@$tiddleurl/$proj/tiddlers/overview |tr -d "#  [[" | tr -d "]]"| while read line;
do
echo -e $n"\t"$line
((n++))
done
} # Test:bin/chello.sh dlr (assume that ss is right)
#
#
######################################STANDARD AND MAYBE USEFUL FUNCTIONS BELOW
#
#
#* function uroot - Checks to see if you are root
function uroot(){
# echo "Make sure only root can run script"
if [ "$(id -u)" != "0" ]; then
   echo "This script does not need to run as root but that's OK as you are not root" 1>&2
fi
} # Test:~flint/bin/chello.sh uroot
#
#* function spause   - A simple tarry...
function spause(){
   # -t sets time
   # read -t $pt -p "$*" ans
   read -p "Hit enter to continue..." ans
   echo $ans
}
#
#*###################################### MAIN ENTRY POINT AND COMPOUND CASE
#
# echo "chello.sh v"$version" starts"
#* Evaluator Routine
# Note the evaluator allows for many cases and error checking...
# ARGS=$#         # carries the number of args into the functions...
if [ "$#" -eq "4" ] && [ "$1" = "sett"     ]; then ARGS="4"; fi
if [ "$#" -eq "1" ] && [ "$1" = "showt"    ]; then ARGS="1"; fi
if [ "$#" -eq "2" ] && [ "$1" = "maket"    ]; then ARGS="2"; fi
if [ "$#" -eq "2" ] && [ "$1" = "remt"     ]; then ARGS="2"; fi
if [ "$#" -eq "2" ] && [ "$1" = "settt"    ]; then ARGS="2"; fi
if [ "$#" -eq "2" ] && [ "$1" = "setst"    ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "popgp"    ]; then ARGS="1"; fi
if [ "$#" -eq "2" ] && [ "$1" = "mktdl"    ]; then ARGS="2"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dlt"      ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dlr"      ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "overview" ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "dummy"    ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "uroot"    ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "spause"   ]; then ARGS="1"; fi
if [ "$#" -eq "1" ] && [ "$1" = "help"     ]; then ARGS="9"; fi
# this tests the evaluator...
#debug echo $#"     "$1"    "$2"    "$3"    "$ARGS ;spause 
# typical cases, be careful to make your own...
case "$ARGS" in
    "0") clear; $1="help"; exit 1;;			        # got nothing, display help and go
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
echo "On "$(date +%F\ %r) $0" version "$version" stops"
#debug echo  "That's all folks!!"
#
#debug rm -rf ss # removes super secret data file
#* restore environment
cd "$S"
