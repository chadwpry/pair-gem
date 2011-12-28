require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pair::Notification::OSXDispatcher do
  describe "when using lion" do
    before do
      @growl = mock('gntp', :register => true, :notify => true)
      GNTP.stub!(:new).and_return(@growl)
      Pair.stub_chain(:config, :growl_enabled?).and_return(true)
      Pair::OS.stub!(:os_x?).and_return(true)
    end

    describe "when initializing" do
      it "is an OSXDispatcher" do
        Pair::Notification.dispatcher.class.should be(Pair::Notification::OSXDispatcher)
      end

      it "registers the application" do
        @growl.should_receive(:register)
        Pair::Notification.dispatcher
      end
    end

    describe "notifications" do
      it "includes session events" do
        Pair::Notification::OSXDispatcher::NOTIFICATIONS.should == [
          {:name => "Session Events", :enabled => true}
        ]
      end
    end

    describe "when registering an application" do
      it "creates a growl network transfer protocol object" do
        GNTP.should_receive(:new).and_return(@growl)
        Pair::Notification.dispatcher
      end
    end

    describe "sending a growl network notification" do
      it "calls gntp notify" do
        a_message_hash = {
          :text => "some text", :name => "Session Events", :title => "a title",
          :icon => "http://#{Pair::APPLICATION_DOMAIN}/test.png", :sticky => false
        }

        @growl.should_receive(:notify).with(a_message_hash)
        dispatcher = Pair::Notification.dispatcher.gntp_notify(a_message_hash)
      end
    end
  end
end
