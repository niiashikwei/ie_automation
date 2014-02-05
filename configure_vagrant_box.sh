#!/bin/sh

set -ex

#rm -rf vm/
#mkdir vm
#cd vm

#vagrant init

#get host ip
host_ip=`ifconfig en0 inet | grep inet | awk '{print $2}'`
echo "host ip is $host_ip"

#get guest ip
guest_ip=`VBoxManage guestproperty get "IE10 - Win7" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`
echo "guest ip is $guest_ip"

sshpass -p vagrant ssh vagrant@$guest_ip -p 2222

