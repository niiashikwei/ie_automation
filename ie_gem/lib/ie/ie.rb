
module IE
  IE9_VM_NAME = "IE9 - Win7"
  DOWNLOAD_DIR = 'tmp'
  DEPENDENCIES = ['vagrant', 'VBoxManage', 'awk']

  def self.get_ie9_vm_name
    IE9_VM_NAME
  end

  def self.get_ie9_vm_ip
    ie9_vm_ip = `VBoxManage guestproperty get "#{IE9_VM_NAME}" '/VirtualBox/GuestInfo/Net/0/V4/IP' | awk '{print $NF}'`[0..-2]
    ie9_vm_ip
  end

  def self.setup_ie9_env
    ENV[IE9_VM_NAME] = get_ie9_vm_ip

    if ENV[IE9_VM_NAME].present? and ( ENV[IE9_VM_NAME].size > 0 )
      puts "configuring selenium driver to point to #{IE9_VM_NAME} VM at #{ENV[IE9_VM_NAME]}"
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

  def self.tear_down_ie9_env
    ENV[IE9_VM_NAME] = ""
    Capybara.default_driver = :selenium
  end

  def self.download_ie9_vm
    Dir.mkdir DOWNLOAD_DIR unless Dir.entries('.').include?(DOWNLOAD_DIR)

    puts "downloading #{IE9_VM_NAME} image..."
    base_url = "http://www.modern.ie/vmdownload?platform=mac&virtPlatform=virtualbox&browserOS=IE9-Win7&filename=VirtualBox/IE9_Win7/Mac/"
    parts = ["IE9.Win7.For.MacVirtualBox.part1.sfx", "IE9.Win7.For.MacVirtualBox.part2.rar", "IE9.Win7.For.MacVirtualBox.part3.rar", "IE9.Win7.For.MacVirtualBox.part4.rar"]

    m = Curl::Multi.new

    parts.each do |part_name|
      url = base_url + part_name
      c = Curl::Easy.new(url) do |curl|
        curl.follow_location = true
        curl.on_body{|data| File.open( "#{DOWNLOAD_DIR}/part_name", 'w') { |f| f.write(data) } }
        curl.on_success {|easy| puts 'download finished successfully' }
        curl.on_failure {|easy| puts 'download failed' }
      end
      m.add(c)
    end

    m.perform
  end

  def self.unzip_appliance
    system "chmod +x #{DOWNLOAD_DIR}/*.sfx"
    system './*.sfx'
  end

  def self.import_appliance
    appliance_path = "#{DOWNLOAD_DIR}/#{IE9_VM_NAME}.ova"
    puts "importing '#{appliance_path}' as appliance..."
    system "VboxManage import '#{appliance_path}'"
  end

  def self.dependencies_met?
    missing_dependencies = []
    puts "checking command line tools dependencies...."
    DEPENDENCIES.each do |command_line_tool|
      tool_exists = system "which #{command_line_tool}"
      if tool_exists
        puts "#{command_line_tool} dependency met"
      else
        missing_dependencies << command_line_tool
      end
    end
    puts "Please install the following missing dependencies: \n #{missing_dependencies}" if (missing_dependencies.size > 0)
  end

end
