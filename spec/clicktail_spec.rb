require File.dirname(__FILE__) + '/spec_helper'

describe "Clicktale controller methods", :type => :controller do
  Object.send(:remove_const, :MockController) rescue nil
  class MockClicktalesController < ActionController::Base
    include Clicktale::Controller
    
    def spec_action
      render :text => "clicktale spec content", :content_type => "text/html;"
    end
  end
  controller_name :mock_clicktales
  
  before(:each) do
    @mock_cache = {}
    def @mock_cache.write(key, value, options = {})
      self[key] = value
    end
    
    controller.stub!(:perform_caching).and_return(true)

    controller.stub(:clicktale_config).and_return({ :enabled => true })
    Rails.stub(:cache).and_return(@mock_cache)
  end
  
  context "clicktale is not enabled" do
    it "should not set the cache" do
      controller.stub(:clicktale_config).and_return({ :enabled => false })
      get :spec_action
      response.body.should =~ /clicktale spec content/
      @mock_cache.keys.should be_empty
    end
    
  end

  context "clicktale is enabled, and a post is made" do
    it "should not set the cache" do
      post :spec_action
      response.body.should =~ /clicktale spec content/
      @mock_cache.keys.should be_empty
    end
  end

  context "clicktale is enabled, and a get for html format is made" do
    it "should set the cache with the request body" do
      get :spec_action
      @mock_cache.keys.length.should == 1
      @mock_cache[@mock_cache.keys.first].should =~ /clicktale spec content/
    end
    
    it "should use different cache keys for subsequent requests" do
      pending "figure out how to instantiate a new controller between gets"
      get :spec_action
      get :spec_action
      @mock_cache.keys.length.should == 2
    end
    
    it "should return the expected clicktale url" do
      get :spec_action
      clicktale_cache_token = ActiveSupport::SecureRandom.hex(32)
      controller.stub(:clicktale_cache_token).and_return(clicktale_cache_token)
      # Not sure how to handle this, I don't want to unprotect the action...
      controller.send(:clicktale_url).should == "http://test.host/clicktales/#{clicktale_cache_token}"
    end
    
    it "should send the expires_in option when writing if configured" do
      controller.stub(:clicktale_config).and_return({ :enabled => true, :expires_in => 120 })
      @mock_cache.should_receive(:write).with(anything(), anything(), { :expires_in => 120 })
      get :spec_action
    end

    it "should not send the expires_in option when writing if not configured to" do
      controller.stub(:clicktale_config).and_return({ :enabled => true, :expires_in => nil })
      @mock_cache.should_receive(:write).with(anything(), anything(), { })
      get :spec_action
    end
  end
end

describe "Clicktale helper methods" do
  before(:each) do
    @object_with_helper = Object.new
    @object_with_helper.extend(Clicktale::Helper)
  end
  
  describe "#clicktale_top" do
    it "should not render the partial if not clicktale enabled" do
      @object_with_helper.stub!(:clicktale_enabled?).and_return(false)
      @object_with_helper.should_not_receive(:render)
      @object_with_helper.clicktale_top
    end
    
    it "should render the clicktail/top partial if clicktale is enabled" do
      @object_with_helper.stub!(:clicktale_enabled?).and_return(true)
      @object_with_helper.should_receive(:render).with(:partial => "clicktale/top")
      @object_with_helper.clicktale_top
    end
  end
  
  describe "#clicktale_bottom" do
    context "when rendering is not enabled" do
      it "should not render the partial" do
        @object_with_helper.stub!(:clicktale_enabled?).and_return(false)
        @object_with_helper.should_not_receive(:render)
        @object_with_helper.clicktale_bottom
      end
    end
    
    context "when rendering is enabled" do
      before(:each) do
        @object_with_helper.stub!(:clicktale_enabled?).and_return(true)
        @object_with_helper.stub(:clicktale_config).and_return({
          :project_id => 42,
          :ratio  => 50,
          :tag => "spec_tag",
          :param => "spec_param"
        })
        @object_with_helper.stub(:clicktale_url).and_return("http://test.host/clicktale_spec_url")
      end
      
      it "should render the clicktail/bottom partial" do
        @object_with_helper.should_receive(:render).with(hash_including(:partial => "clicktale/bottom"))
        @object_with_helper.clicktale_bottom
      end
      
      it "should render the partial with the expected locals" do
        expected_locals =
          { :path=>"http://test.host/clicktale_spec_url", :tag => "spec_tag", :project_id => 42, :ratio => 50, :param => "spec_param" }
          
        @object_with_helper.should_receive(:render).with(hash_including(:locals => expected_locals))
        @object_with_helper.clicktale_bottom
      end
    end
  end
end

describe "Clicktale routing" do
  it "should route /clicktales/:id to the clicktales controller show action" do
    ActionController::Routing::Routes.draw { |map| map.clicktales }
    routes = ActionController::Routing::Routes
    routes.recognize_path("/clicktales/foo").should == { :controller => "clicktales", :action => "show", :id => "foo" }
  end
end
