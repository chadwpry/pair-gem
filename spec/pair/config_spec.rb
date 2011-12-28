require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pair/config'

describe Pair::Config do
  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }
  let(:host)   { "api.domain.com" }

  let(:config) { described_class.new(host, stdin, stdout) }

  describe "when accessing a proper configuration yml" do
    before do
      yaml_store = YAML::Store.new("spec/fixtures/config/rspec.pair.yml")
      YAML::Store.stub!(:new).and_return(yaml_store)
    end

    it "returns the api_token" do
      Pair::Config.new.api_token.should == "XXXXXXXXXXXXXXXXXXXX"
    end

    it "is growl enabled" do
      Pair::Config.new.should be_growl_enabled
    end

    it "is ssh enabled" do
      Pair::Config.new.should be_ssh_enabled
    end
  end

  describe "when missing growl_enabled in the config" do
    before do
      yaml_store = YAML::Store.new("spec/fixtures/config/rspec_no_growl_enabled.pair.yml")
      YAML::Store.stub!(:new).and_return(yaml_store)
    end

    it "is not growl enabled" do
      config = Pair::Config.new
      config.should_not be_growl_enabled
    end
  end

  describe "when missing ssh_enabled in the config" do
    before do
      yaml_store = YAML::Store.new("spec/fixtures/config/rspec_no_ssh_enabled.pair.yml")
      YAML::Store.stub!(:new).and_return(yaml_store)
    end

    it "is not ssh enabled" do
      config = Pair::Config.new
      config.should_not be_ssh_enabled
    end
  end

  context "for different hosts" do
    before do
      config_hash = {}
      YAML::Store.stub!(:new => config_hash)
      def config_hash.transaction
        yield
      end
    end

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
    before do
      config_hash = {}
      YAML::Store.stub!(:new => config_hash)
      def config_hash.transaction
        yield
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
