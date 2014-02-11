#!/bin/sh

set -ex

#get guest ip
guest_ip=`VBoxManage guestproperty get "IE10 - Win7" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`
echo "guest ip is $guest_ip"
export IE10_VM_IP="$guest_ip"

#run selenium server
cmd0="cd workdir"
cmd1="java -jar selenium-server-standalone-2.39.0.jar"

#restore from snapshot 'selenium running'
VBoxManage snapshot "IE9 - Win7" -take "selenium running"

#run selenium server
echo "starting selenium server"
sshpass -p password ssh ieuser@$guest_ip -p 2222 "$cmd0 && $cmd1"
