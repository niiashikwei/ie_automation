#!/bin/sh

set -ex

##########
echo "Need to install ssh server on win vm listening at port 2222,"
echo "\nadd the local windows account,"
echo "\nand turn off windows firewall"
echo "before doing next steps"
##########

#get host ip
host_ip=`ifconfig en0 inet | grep inet | awk '{print $2}'`
echo "host ip is $host_ip"

#get guest ip
guest_ip=`VBoxManage guestproperty get "IE9 - Win7" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`
echo "guest ip is $guest_ip"


#create workdir
sshpass -p Passw0rd! ssh ieuser@$guest_ip -p 2222 "mkdir workdir || echo \"directory already exists!\"" 

function send_command {
  sshpass -p Passw0rd! ssh ieuser@$guest_ip -p 2222 "cd workdir && $1"
}

#download selenium jar
selenium_version="selenium-server-standalone-2.39.0"
cmd2="wget -nc https://www.dropbox.com/s/yer2hc25lfvtjne/$selenium_version.jar -O $selenium_version.jar --no-check-certificate || echo 'selenium jar already present in directory'"
send_command "$cmd2"

#download ie driver, extract and add to path
send_command "mkdir drivers || echo 'drivers directory already exists!'"

driver_version="IEDriverServer_Win32_2.39.0"
cmd3="cd drivers && wget -nc https://selenium.googlecode.com/files/$driver_version.zip --no-check-certificate || echo 'driver already downloaded!'"
send_command "$cmd3"

cmd4="cd drivers && unzip -u $driver_version.zip"
send_command "$cmd4"

#edit host file
cmd6="echo $host_ip          localtest.me >>  C:\Windows\System32\drivers\etc\hosts"
send_command "$cmd6"

#seed commands
cmd7="cd C:\Users\IEUser\\\"My Documents\""
cmd8="touch default_file some_pdf.pdf some_ppt.ppt text_file.txt another_txt_file.txt"
cmd9="cd C:\Users\IEUser\workdir"
seed_cmds="$cmd7 && $cmd8 && $cmd9"
send_command $seed_cmds

VBoxManage snapshot "IE9 - Win7" -take "selenium running"
