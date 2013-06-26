require 'spec_helper'

describe Celluloid::IO::DNSResolver do
  describe '.hosts' do
    let(:hosts_path) { Pathname.new(__FILE__).join("../../../fixtures/hosts") }
    let(:host_hash) do
      {
        "localhost"=>"127.0.0.1",
        "broadcasthost"=>"255.255.255.255"
      }
    end

    it 'returns all hosts listed in the hosts file' do
      described_class.hosts(hosts_path).should eq host_hash
    end
  end

  describe '#resolve' do
    it 'resolves hostnames' do
      resolver = Celluloid::IO::DNSResolver.new
      resolver.resolve('localhost').should eq Resolv::IPv4.create("127.0.0.1")
    end

    it "resolves domain names" do
      resolver = Celluloid::IO::DNSResolver.new
      resolver.resolve("celluloid.io").should == Resolv::IPv4.create("207.97.227.245")
    end

    it "resolves CNAME responses" do
      resolver = Celluloid::IO::DNSResolver.new
      results = resolver.resolve("www.google.com")
      if results.is_a?(Array)
        results.all? {|i| i.is_a?(Resolv::IPv4) }.should be_true
      else
        results.is_a?(Resolv::IPv4).should be_true
      end
      # www.yahoo.com will be resolved randomly whether multiple or
      # single entry.
      results = resolver.resolve("www.yahoo.com")
      if results.is_a?(Array)
        results.all? {|i| i.is_a?(Resolv::IPv4) }.should be_true
      else
        results.is_a?(Resolv::IPv4).should be_true
      end
    end
  end
end
