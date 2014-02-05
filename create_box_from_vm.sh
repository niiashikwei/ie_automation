#!/bin/sh

#set -ex

fileExists () {
  file_name=${1}
  if [ -s $file_name ]
  then
    echo "$file_name exists"
  else
    echo "$file_name doesn't exist"
  fi
}

#file="VagrantFile"
#fileExists $file

vagrant_version=`vagrant -v | awk '{ print $NF }'`
echo "vagrant version: $vagrant_version"
if [[ -z $vagrant_version ]] ; then
  echo "vagrant not installed or not in path! quitting.."
  exit
else
  vagrant_box=`vagrant box list | grep 'IE10 - Win7'`
  if [[ -z $vagrant_box ]] ; then
    echo "creating box..."
    vagrant package --base 'IE10 - Win7' --output win7_ie10.box
    
    echo "adding 'IE10 - Win7' box to vagrant"
    vagrant box add 'IE10 - Win7' win7_ie10.box
  else
    echo "vagrant box '$vagrant_box' already exists...skipping packaging and addition"
  fi
fi

echo "cleaning up"
rm *.ova
VBoxManage unregistervm 'IE10 - Win7'
