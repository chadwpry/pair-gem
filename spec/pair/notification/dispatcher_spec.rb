require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pair::Notification::Dispatcher do
  before do
    Pair.stub_chain(:config, :growl_enabled?).and_return(false)
  end

  describe "when initializing" do
    it "uses the STDOUT for logging by default" do
      Pair::Notification.dispatcher.logger == STDOUT
    end

    it "uses the logger provided as a parameter" do
      logger = mock('a logger')
      Pair::Notification::Dispatcher.new(:logger => logger).logger.should == logger
    end
  end
end
