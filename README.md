ie_automation
=============

###scripts for setting up, downloading and configuring ie boxes###

#script order
1) download_unzip_and_import_ie9_vm.sh
2) create_box_from_vm.sh
3) A few manual steps
 - here you actually need to set up an ssh server on the windows box, listening at 2222. I used Bitvise.
   Make sure you add the local windows account : IEUser
 - turn off windows firewall
 - turn of UAC
 - install some bash command line tools (i used the tools that came with git for windows)
 - install java, wget
4) configure_vagrant_box.sh
5) run_selenium_server.sh

After running the server make sure you set the env variable that playlist builder is looking for
Refer to confluence page on "ie automation"
relevant file: <project root>/features/support/env.rb

#default Login Information(forWindowsVista,7,8VMs):
IEUser,Passw0rd!                    




