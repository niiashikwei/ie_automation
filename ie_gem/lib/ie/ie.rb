
class IE
  def self.hi
    puts "Hello my ie friends!"
  end

  def self.download_ie_vm(ie_version)
    puts 'downloading win7 IE9 image...'
    system "curl -O -L 'http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE#{ie_version}-Win7&filename=VirtualBox/IE#{ie_version}_Win7/Mac/IE#{ie_version}.Win7.For.MacVirtualBox.part{1.sfx,2.rar,3.rar,4.rar}'"
  end

  def self.unzip_image
    puts 'unziping image...'
    system  "chmod +x IE9.Win7.For.MacVirtualBox.part1.sfx"
    system  "./IE9.Win7.For.MacVirtualBox.part1.sfx"
  end

  def self.check_for_vm(vm_name)
    puts "checking for vm with name #{vm_name}"
    system "VboxManage list vms | grep 'IE9 - Win7' | awk '{ print $1 $2 $3}'"
  end

  def self.import_appliance
    puts 'importing appliance'
    system "VboxManage import 'IE9 - Win7.ova'"
  end

  def self.clean_up
    puts 'cleaning up'
    system "rm *.rar *.sfx"
  end

  def self.setup_for_ie()
    if ENV['IE9_VM_IP'].present?
      selenium_server_host_ip = ENV['IE9_VM_IP']
      selenium_server_url = "http://#{selenium_server_host_ip}:4444/wd/hub"

      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app,
                                       :browser => :remote,
                                       :url => selenium_server_url,
                                       :desired_capabilities => :internet_explorer
                                      )
      end
    end
  end

end
