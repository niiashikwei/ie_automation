require_relative '../spec_helper'

describe IE do
  describe "setup" do
    before :each do
      ENV.stub(:[]).with("IE9_VM_IP").and_return("1.2.3.4")
    end

    it "should assign the environment variable for ie9 if it exists" do
      IE.get_ie9_vm_ip.should == "1.2.3.4"
    end
  end

  describe "download_ie9_vm" do
  end
end