#!/bin/sh

set -ex

vbox_version=`VBoxManage -v`
if [[ -z $vbox_version ]] ; then
  echo "Virtual box not installed or not in path! Quitting"
  exit
else
  echo "VBoxManage version is '$vbox_version'"
fi

#download win7 IE9 image
if [[ ! -f IE9.Win7.For.MacVirtualBox.part1.sfx ]] ; then
  echo "downloading win7 IE9 image..."
  curl -O -L "http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE9-Win7&filename=VirtualBox/IE9_Win7/Mac/IE9.Win7.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar}"
else
  echo "zip file already exists...skipping download"
fi

#unzip image and clean up
if [[ ! -f 'IE9 - Win7.ova' ]] ; then
  echo "unziping image..."
  chmod +x IE9.Win7.For.MacVirtualBox.part1.sfx
  ./IE9.Win7.For.MacVirtualBox.part1.sfx
else
  echo "IE9 - Win7.ova exists...skipping unzip"
fi

vm_name=`VboxManage list vms | grep 'IE9 - Win7' | awk '{ print $1 $2 $3}'`
expected_vm_name=\"IE9-Win7\"
if [[ $vm_name == $expected_vm_name ]] ; then
  echo "VM with name '$vm_name' exists. Skipping import ..."
else
  echo "VM with name '$vm_name' does not exist."
  echo "importing 'IE9 - Win7.ova' as appliance..."
  #import image as appliance
  VboxManage import 'IE9 - Win7.ova'
fi


echo "cleaning up"
rm *.rar *.sfx



