require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pair/config'

describe Pair::Config do
  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }
  let(:host)   { "api.domain.com" }

  let(:config) { described_class.new(host, stdin, stdout) }

  before do
    config_hash = {}
    YAML::Store.stub!(:new => config_hash)
    def config_hash.transaction
      yield
    end
  end

  context "for different hosts" do
    it "has a different set of configs for each host" do
      host1, host2 = "api.domain.com", "api.beta.domain.com"
      config1 = described_class.new(host1)
      config2 = described_class.new(host2)
      config3 = described_class.new(host1)

      config1.a_setting = "setting 1"
      config2.a_setting = "setting 2"

      config1.a_setting.should == "setting 1"
      config3.a_setting.should == "setting 1"
      config2.a_setting.should == "setting 2"
    end
  end

  describe '#api_token' do
    context "when none is saved" do
      it "prompts for key to be entered" do
        response = "abc123"
        stdin << "#{response}\n"
        stdin.rewind

        config.api_token.should == response

        stdout.rewind
        stdout.read.should == "Please input your API token for Pair: "
      end

      it "saves the key" do
        stdin.should_receive(:gets).once.and_return("abc123\n")
        config.api_token
        config.api_token
      end
    end

    context "when one is already saved" do
      it "returns the saved value" do
        api_token = "abc123"
        config.api_token = api_token
        config.api_token.should == api_token
      end
    end
  end
end
