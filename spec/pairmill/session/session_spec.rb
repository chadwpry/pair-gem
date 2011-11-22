require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pairmill::Session do
  let(:host) { "chad.pry@gmail.com" }
  let(:name) { "testing-conference" }

#  describe "when joining a session" do
#    describe "the returned session" do
#      let(:joined_session) { Pairmill::Session::JoinedSession.new(host, name) }
#
#      before do
#        Pairmill::Session::JoinedSession.stub!(:new).and_return(joined_session)
#      end
#
#      it "starts a joined session" do
#        joined_session.should_receive(:start!)
#        Pairmill::Session.join(:host => host, :session_name => name)
#      end
#    end
#  end

  describe "starting a session" do
    let(:session_json) { FixtureHelper.api_joined_session }

    before do
      Pairmill::Api.stub!(:join_session).and_return(session_json)
    end

    it "fetches a session from the api" do
      session = Pairmill::Session::JoinedSession.new(host, name)
      session.should_receive(:fetch_session_details)
      session.start!
    end
    
    it "returns a joined session instance" do
      session = Pairmill::Session::JoinedSession.new(host, name)
      session.should be_a(Pairmill::Session::JoinedSession)
    end
  end
end
