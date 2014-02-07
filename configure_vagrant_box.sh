#!/bin/sh

set -ex

#create vm folder
echo "create vm folder"
if [[ -d vm ]] ; then
    rm -rf vm/
fi

#setup vagrant/vagrant file
echo "setup vagrant/vagrant file"
mkdir vm
cd vm
vagrant init
rm Vagrantfile
cp ../Vagrantfile.sample Vagrantfile

#start up vm
echo "starting up vm"
vagrant up

#get host ip
host_ip=`ifconfig en0 inet | grep inet | awk '{print $2}'`
echo "host ip is $host_ip"

#get guest ip
guest_ip=`VBoxManage guestproperty get "IE9 - Win7" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`
echo "guest ip is $guest_ip"

#move to workdir
cmd0="cd workdir"

#download selenium jar
selenium_version="selenium-server-standalone-2.39.0"
cmd1="wget https://www.dropbox.com/s/yer2hc25lfvtjne/$selenium_version.jar -O $selenium_version.jar --no-check-certificate"

#download ie driver, extract and add to path
driver_version="IEDriverServer_Win32_2.39.0"
cmd2="wget https://selenium.googlecode.com/files/$driver_version.zip -O drivers\\$driver_version.zip --no-check-certificate"
cmd3="unzip drivers\\$driver_version.zip -d drivers"
cmd4="rm drivers\\$driver_version.zip"

#edit host file
cmd5="echo $host_ip          localtest.me >>  C:\Windows\System32\drivers\etc\hosts"

#seed commands
cmd6="cd C:\Users\IEUser\\\"My Documents\""
cmd7="touch default_file some_pdf.pdf some_ppt.ppt text_file.txt another_txt_file.txt"
cmd8="cd C:\Users\IEUser\workdir"
seed_cmds = "$cmd6 && $cmd7 && $cmd8"

cmds="$cmd0 && $cmd1 && $cmd2 && $cmd3 && $cmd4 && $cmd5 && seed_cmds"

#ssh into vm and download server and driver
echo downloading selenium server and driver
sshpass -p Passw0rd! ssh ieuser@$guest_ip -p 2222 $cmds

