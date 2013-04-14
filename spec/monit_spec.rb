# -*- encoding: utf-8 -*-
require "spec_helper"

SMALLISH_STATUS_PATH  = File.expand_path("../samples/smallish_status.xml", __FILE__)
LARGISH_STATUS_PATH   = File.expand_path("../samples/largish_status.xml", __FILE__)

describe Monit do
  describe "Status" do
    it "should be possible to instatiate it with no options" do
      @status = Monit::Status.new
      @status.should be_kind_of Monit::Status
      @status.host.should == "localhost"
      @status.port.should == 2812
      @status.ssl.should be_false
      @status.auth.should be_false
      @status.username.should be_nil
      lambda { @status.password }.should raise_error(NoMethodError)
      @status.services.should == []
    end
    
    it "should generate the correct URL" do
      @status = Monit::Status.new
      @status.url.should be_kind_of URI
      @status.url.to_s.should == "http://localhost:2812/_status?format=xml"
      @status.ssl = true
      @status.url.to_s.should == "https://localhost:2812/_status?format=xml"
      @status.host = "rails.fi"
      @status.url.to_s.should == "https://rails.fi:2812/_status?format=xml"
      @status.port = 8080
      @status.url.to_s.should == "https://rails.fi:8080/_status?format=xml"
    end
    
    it "should parse XML into a Hash" do
      status = Monit::Status.new
      status.stub!(:xml).and_return(File.read(SMALLISH_STATUS_PATH))
      status.parse(status.xml)
      status.hash.should be_kind_of Hash
      status.hash["monit"].should_not be_nil
      status.hash["monit"]["server"].should_not be_nil
      status.hash["monit"]["platform"].should_not be_nil
      status.hash["monit"]["service"].should_not be_nil
      
      status.stub!(:xml).and_return(File.read(LARGISH_STATUS_PATH))
      status.parse(status.xml)
      status.hash.should be_kind_of Hash
      status.hash["monit"].should_not be_nil
      status.hash["monit"]["server"].should_not be_nil
      status.hash["monit"]["platform"].should_not be_nil
      status.hash["monit"]["service"].should_not be_nil
    end
    
    it "should parse XML into a Ruby representation" do
      status = Monit::Status.new
      status.stub!(:xml).and_return(File.read(SMALLISH_STATUS_PATH))
      status.parse(status.xml)
      
      status.server.should be_kind_of Monit::Server
      status.server.httpd.should be_kind_of Monit::HTTPD
      status.platform.should be_kind_of Monit::Platform
      status.services.should be_kind_of Array
      status.services.first.should be_kind_of Monit::Service
      status.services.first.should be_kind_of OpenStruct
      
      status.stub!(:xml).and_return(File.read(LARGISH_STATUS_PATH))
      status.parse(status.xml)
      
      status.server.should be_kind_of Monit::Server
      status.server.httpd.should be_kind_of Monit::HTTPD
      status.platform.should be_kind_of Monit::Platform
      status.services.should be_kind_of Array
      status.services.first.should be_kind_of Monit::Service
      status.services.first.should be_kind_of OpenStruct
    end
  end
  
  describe "Server" do
    it "should create a new instance of Monit::Server from a hash" do
      hash = {         "id" => "52255a0b8999c46c98de9697a8daef67",
              "incarnation" => "1283946152",
                  "version" => "5.1.1",
                   "uptime" => "4",
                     "poll" => "30",
               "startdelay" => "0",
            "localhostname" => "Example.local",
              "controlfile" => "/etc/monitrc",
                    "httpd" => { "address" => nil,
                                    "port" => "2812",
                                     "ssl" => "0" } }
      server = Monit::Server.new(hash)
      server.id.should == "52255a0b8999c46c98de9697a8daef67"
      server.incarnation.should == "1283946152"
      server.version.should == "5.1.1"
      server.uptime.should == 4
      server.poll.should == 30
      server.startdelay.should == 0
      server.localhostname.should == "Example.local"
      server.controlfile.should == "/etc/monitrc"
      server.httpd.should be_kind_of Monit::HTTPD
    end
  end
  
  describe "HTTPD" do
    it "should create a new instance of Monit::HTTPD from a hash" do
      hash = { "address" => nil,
                  "port" => "2812",
                   "ssl" => "0" }
      httpd = Monit::HTTPD.new(hash)
      httpd.address.should be_nil
      httpd.port.should == 2812
      httpd.ssl.should be_false
    end
  end
  
  describe "Platform" do
    it "should create a new instance of Monit::Platform from a hash" do
      hash = { "name" => "Darwin",
            "release" => "10.4.0",
            "version" => "Darwin Kernel Version 10.4.0: Fri Apr 23 18:28:53 PDT 2010; root:xnu-1504.7.4~1/RELEASE_I386",
            "machine" => "i386",
                "cpu" => "2",
             "memory" => "4194304" }
      platform = Monit::Platform.new(hash)
      platform.name.should == "Darwin"
      platform.release.should == "10.4.0"
      platform.version.should == "Darwin Kernel Version 10.4.0: Fri Apr 23 18:28:53 PDT 2010; root:xnu-1504.7.4~1/RELEASE_I386"
      platform.machine.should == "i386"
      platform.cpu.should == 2
      platform.memory.should == 4194304
    end
  end
  
  describe "Service" do
    let(:service) do
      hash = { "collected_sec" => "1283946152",
              "collected_usec" => "309973",
                        "name" => "Example.local",
                      "status" => "0",
                 "status_hint" => "0",
                     "monitor" => "1",
                 "monitormode" => "0",
               "pendingaction" => "0",
                      "groups" => { "name" => "server" },
                      "system" => { "load" => { "avg01" => "0.28",
                                                "avg05" => "0.43",
                                                "avg15" => "0.48" },
                                     "cpu" => {   "user" => "10.0",
                                                "system" => "4.1" },
                                  "memory" => { "percent" => "44.1",
                                               "kilobyte" => "1850152" }
                                  },
                        "type" => "5" }
      Monit::Service.new(hash) 
    end

    it "should create a new instance of Monit::Platform from a hash" do
      service.should be_kind_of OpenStruct
      service.should be_kind_of Monit::Service
      service.collected_sec.should == "1283946152"
      service.collected_usec.should == "309973"
      service.name.should == "Example.local"
      service.status.should == "0"
      service.status_hint.should == "0"
      service.monitor.should == "1"
      service.monitormode.should == "0"
      service.pendingaction.should == "0"
      service.groups.should be_kind_of Hash
      service.system.should be_kind_of Hash
      service.service_type.should == "5"
    end

    describe "#start!" do
      it "sends :start to #do" do
        service.stub(:do).with(:start)
        service.start!
      end
    end

    describe "#stop!" do
      it "sends :stop to #do" do
        service.stub(:do).with(:stop)
        service.stop!
      end
    end

    describe "#restart!" do
      it "sends :restart to #do" do
        service.stub(:do).with(:restart)
        service.restart!
      end
    end

    describe "#monitor!" do
      it "sends :monitor to #do" do
        service.stub(:do).with(:monitor)
        service.monitor!
      end
    end

    describe "#unmonitor!" do
      it "sends :unmonitor to #do" do
        service.stub(:do).with(:unmonitor)
        service.unmonitor!
      end
    end

    describe "#do" do
      it "returns true if the response code is 2xx" do
        stub_request(:any, /localhost/).to_return(status: 200)
        service.do(:start).should == true
        stub_request(:any, /localhost/).to_return(status: 201)
        service.do(:start).should == true
      end

      it "returns false if the response code is not 2xx" do
        stub_request(:any, /localhost/).to_return(status: 500)
        service.do(:start).should == false
        stub_request(:any, /localhost/).to_return(status: 400)
        service.do(:start).should == false
        stub_request(:any, /localhost/).to_return(status: 302)
        service.do(:start).should == false
      end
    end
  end
end
