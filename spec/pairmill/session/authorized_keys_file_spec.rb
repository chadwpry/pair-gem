require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'fileutils'

describe Pairmill::Session::AuthorizedKeysFile do
  let(:member_keys) { FixtureHelper.user_keys }
  let(:session) { "testing-session" }
  let(:subject) { Pairmill::Session::AuthorizedKeysFile.new(member_keys, session) }

  before do
    subject.stub!(:backup_authorized_keys)
    subject.stub!(:create_authorized_keys)
    subject.stub!(:remove_existing_file)
    subject.stub!(:move_backup_file)
  end

  describe "when instantiating an object" do
    it "sets the instance member_keys value" do
      subject.member_keys.should == member_keys
    end

    it "sets the key file path to the current user" do
      subject.key_file_path.should == File.expand_path("~/.ssh/authorized_keys")
    end
  end

  describe "key_file_exists?" do
    it "is true when the key file path exists" do
      File.should_receive(:exists?).with(subject.key_file_path).and_return(true)
      subject.key_file_exists?.should be_true
    end
  end

  describe "backup_key_file_exists?" do
    it "is true when the backup key file path exists" do
      File.should_receive(:exists?).with(subject.backup_key_file_path).and_return(true)
      subject.backup_key_file_exists?.should be_true
    end
  end

  describe "installing an authorized keys file" do
    describe "when an existing file is present" do
      it "is backed up" do
        subject.stub!(:key_file_exists?).and_return(true)
        subject.should_receive(:backup_authorized_keys)
        subject.install
      end

      it "adds a new file" do
        subject.should_receive(:create_authorized_keys)
        subject.install
      end
    end

    describe "when there is not an existing file" do
      it "does not backup" do
        subject.should_not_receive(:move_backup_file)
        subject.install
      end
    end
  end

  describe "cleaning up an authorized keys file" do
    before do
      subject.stub!(:key_file_exists?).and_return(true)
      subject.stub!(:backup_key_file_exists?).and_return(true)
    end

    it "removes the current authorized keys file" do
      subject.should_receive(:remove_existing_file)
      subject.cleanup
    end

    it "moves an existing backup key file" do
      subject.should_receive(:move_backup_file)
      subject.cleanup
    end
  end
end
