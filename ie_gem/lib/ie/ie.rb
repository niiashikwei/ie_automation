
module IE
    def self.download_ie9_vm
      puts 'downloading win7 IE9 image...'
      responses = {}
      base_url = "http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE9-Win7&filename=VirtualBox/IE9_Win7/Mac/IE9.Win7.For.MacVirtualBox.part"
      requests = ["#{base_url}1.sfx", "#{base_url}2.rar", "#{base_url}3.rar", "#{base_url}4.rar"]

      m = Curl::Multi.new

      requests.each do |url|
        responses[url] = ""
        c = Curl::Easy.new(url) do |curl|
          curl.follow_location = true
          curl.on_body{|data| responses[url] << data; data.size }
          curl.on_success {|easy| puts "download finished successfully" }
          curl.on_failure {|easy| puts "download failed" }
        end
        m.add(c)
      end

      m.perform
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


    def self.setup_for_ie9
      ie_vm_ip = ENV['IE9_VM_IP']
      if ie_vm_ip.present?
        selenium_server_url = "http://#{ie_vm_ip}:4444/wd/hub"

        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app,
                                         :browser => :remote,
                                         :url => selenium_server_url,
                                         :desired_capabilities => :internet_explorer
                                        )
        end
      end
    end

  def override_localhost_on_vm
    ##get host ip
    #host_ip=`ifconfig en0 inet | grep inet | awk '{print $2}'`
    #echo "host ip is $host_ip"
    #
    ##get guest ip
    #guest_ip=`VBoxManage guestproperty get "IE9 - Win7" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{
    #echo "guest ip is $guest_ip"
    #
    #
    ##create workdir
    #sshpass -p Passw0rd! ssh ieuser@$guest_ip -p 2222 "mkdir workdir || echo \"directory already exists"
  end

end
