require File.dirname(__FILE__) + '/spec_helper'
require 'fileutils'

describe "A mysql server" do
  before(:each) do
    Dir["#{MOUNT_POINT}/lib/*"].each do |f|
      FileUtils.rm(f)
    end

    if ENV["MOCK"]
      stub(System).run(anything) {|command| MockSystem.run(command) }
    end

    @m = MysqlServer.new
  end

  after(:each) do
    MockSystem.reset! if ENV["MOCK"]
  end

  describe "being installed" do
    describe "on a fresh machine" do
      before(:each) do
        @result = @m.install
      end

      it "succeeds" do
        @result.should be_true
      end

      it "installs the mysql database" do
        output = @m.list
        output.should == "mysql"
      end
    end

    describe "on a machine with it already installed" do
      before(:each) do
        @m.install
      end

      it "raises an error" do
        lambda { @m.install }.
          should raise_error(MysqlServer::AlreadyInstalled, /already installed/)
      end
    end
  end

  describe "without being installed" do
    it "has no databases" do
      output = @m.list
      output.should == ""
    end
  end

  describe "creating a database" do
    describe "when the server is installed" do
      describe "when the database has not been created" do
        before(:each) do
          @m.install
          @result = @m.create_db("test")
        end

        it "succeeds" do
          @result.should be_true
        end

        it "has the new database" do
          output = @m.list
          output.should == "mysql\ntest"
        end
      end

      describe "when the database has been created" do
        before(:each) do
          @m.install
          @m.create_db("test")
        end

        it "raises an error" do
        lambda { @m.create_db("test") }.
          should raise_error(MysqlServer::DbAlreadyExists, /already exists/)
        end
      end
    end

    describe "when the server is not installed" do
      it "raises an error" do
        lambda { @m.create_db("test") }.
          should raise_error(MysqlServer::NotInstalled, /not installed/)
      end
    end
  end

  describe "removing a database" do
    describe "when the server is installed" do
      describe "when the database has been created" do
        before(:each) do
          @m.install
          @m.create_db("test")
          @result = @m.remove_db("test")
        end

        it "succeeds" do
          @result.should be_true
        end

        it "does not have the database anymore" do
          output = @m.list
          output.should == "mysql"
        end
      end

      describe "when the database has not been created" do
        before(:each) do
          @m.install
        end

        it "raises an error" do
          lambda { @m.remove_db("test") }.
            should raise_error(MysqlServer::DbNonExistant, /non-existant/)
        end
      end
    end

    describe "when the server is not installed" do
      it "raises an error" do
        lambda { @m.remove_db("test") }.
          should raise_error(MysqlServer::NotInstalled, /not installed/)
      end
    end
  end
end
