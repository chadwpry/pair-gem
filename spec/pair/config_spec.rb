require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'pair/config'

describe Pair::Config do
  let(:stdin)  { StringIO.new }
  let(:stdout) { StringIO.new }

  let(:config) { described_class.new(stdin, stdout) }

  let(:config_hash) { {} }

  before do
    # Let's not touch the FS ever
    config.stub!(:config => config_hash)
    def config_hash.transaction
      yield
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
        config_hash[:api_token] = api_token
        config.api_token.should == api_token
      end
    end
  end
end
