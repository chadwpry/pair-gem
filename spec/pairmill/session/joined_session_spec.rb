require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pairmill::Session::JoinedSession do
  let(:host) { "chad.pry@gmail.com" }
  let(:name) { "testing-conference" }

  describe "when instantiating an object" do
    it "sets the host" do
      Pairmill::Session::JoinedSession.new(host, name).host.should == host
    end

    it "sets the name" do
      Pairmill::Session::JoinedSession.new(host, name).name.should == name
    end
  end
end
