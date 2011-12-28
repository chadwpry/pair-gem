require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Pair::Notification do
  describe "when using OSX lion" do
    before do
      @gntp = mock(GNTP, :register => true, :notify => true)
      GNTP.stub!(:new).and_return(@gntp)

      Pair::OS.stub!(:os_x?).and_return(true)
      Pair.stub!(:config => stub(:growl_enabled? => true))
    end

    describe "when initializing" do
      it "returns an OSXDispatcher class" do
        Pair::Notification.dispatcher.class.should == Pair::Notification::OSXDispatcher
      end

      it "yields the OSXDispatcher class" do
        Pair::Notification.dispatcher do |dispatcher|
          dispatcher.should == dispatcher
        end
      end
    end

    describe "joining a session" do
      it "notifies via growl notification transfer protocol" do
        @gntp.should_receive(:notify).with({
          :name => "Session Events", :title => "Pair Message",
          :text => "chadwpry joined session \"SESSION_NAME\"",
          :icon => Pair::ICON_SESSION_JOIN, :sticky => true
        })
        Pair::Notification.dispatcher.session_join("chadwpry", "SESSION_NAME")
      end
    end

    describe "parting a session" do
      it "notifies via growl notification transfer protocol" do
        @gntp.should_receive(:notify).with({
          :name => "Session Events", :title => "Pair Message",
          :text => "chadwpry parted session \"SESSION_NAME\"",
          :icon => Pair::ICON_SESSION_JOIN, :sticky => true
        })
        Pair::Notification.dispatcher.session_part("chadwpry", "SESSION_NAME")
      end
    end
  end
end

