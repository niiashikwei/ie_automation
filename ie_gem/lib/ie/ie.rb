
module IE
    def self.download_ie9_vm
      puts 'downloading win7 IE9 image...'
      base_url = 'http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE9-Win7&filename=VirtualBox/IE9_Win7/Mac/IE9.Win7.For.MacVirtualBox'

      [1,2,3,4].each do |num|
        vm_part_url = base_url + ".part#{num}.sfx"
        curl = Curl::Easy.new(vm_part_url)
        file_extension = num.eql? 1 ? "sfx" : "rar"
        curl.on_body {
            |d| f = File.new("part#{num}.#{file_extension}", 'w') {|f| f.write d}
        }
        curl.perform
      end
    end

    def self.get_ie9_vm_ip
      ENV["IE9_VM_IP"]
    end

    #def self.unzip_image
    #  puts 'unziping image...'
    #  system  "chmod +x IE9.Win7.For.MacVirtualBox.part1.sfx"
    #  system  "./IE9.Win7.For.MacVirtualBox.part1.sfx"
    #end
    #
    #def self.check_for_vm(vm_name)
    #  puts "checking for vm with name #{vm_name}"
    #  system "VboxManage list vms | grep 'IE9 - Win7' | awk '{ print $1 $2 $3}'"
    #end
    #
    #def self.import_appliance
    #  puts 'importing appliance'
    #  system "VboxManage import 'IE9 - Win7.ova'"
    #end
    #
    #def self.clean_up
    #  puts 'cleaning up'
    #  system "rm *.rar *.sfx"
    #end
    #
    #def self.setup_for_ie
    #  if ENV['IE9_VM_IP'].present?
    #    selenium_server_host_ip = ENV['IE9_VM_IP']
    #    selenium_server_url = "http://#{selenium_server_host_ip}:4444/wd/hub"
    #
    #    Capybara.register_driver :selenium do |app|
    #      Capybara::Selenium::Driver.new(app,
    #                                     :browser => :remote,
    #                                     :url => selenium_server_url,
    #                                     :desired_capabilities => :internet_explorer
    #                                    )
    #    end
    #  end
    #end

end
