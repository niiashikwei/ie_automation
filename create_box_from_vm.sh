#!/bin/sh

#set -ex


vagrant_version=`vagrant -v | awk '{ print $NF }'`
echo "vagrant version: $vagrant_version"

if [[ -z $vagrant_version ]] ; then
  echo "vagrant not installed or not in path! quitting.."
  exit
else
  vagrant_box=`vagrant box list | grep 'IE9 - Win7'`
  if [[ -z $vagrant_box ]] ; then
    echo "creating box..."
    vagrant package --base 'IE9 - Win7' --output win7_ie9.box
    
    echo "adding 'IE9 - Win7' box to vagrant"
    vagrant box add 'IE9 - Win7' win7_ie9.box
    vagrant box list
    VBoxManage unregistervm 'IE9 - Win7' --delete

    ##start up vagrant box
    echo "start up vagrant box"

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
  else
    echo "vagrant box '$vagrant_box' already exists...skipping packaging and addition"
  fi
fi

echo "cleaning up"
rm *.ova
