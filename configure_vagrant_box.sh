#!/bin/sh

set -ex

#create vm folder
echo "create vm folder"
rm -rf vm/
mkdir vm
cd vm

#setup vagrant/vagrant file
echo "setup vagrant/vagrant file"
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
guest_ip=`VBoxManage guestproperty get "IE10 - Win7" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`
echo "guest ip is $guest_ip"

#download selenium jar
cmd1="curl https://www.dropbox.com/s/yer2hc25lfvtjne/selenium-server-standalone-2.39.0.jar"

#download ie driver
cmd2="curl https://www.dropbox.com/s/bqiaajofm5244oz/IEDriverServer_x64_2.39.0.zip"

#ssh into vm and download server and driver
sshpass -p password ssh ieuser@$guest_ip -p 2222 $cmd1
