require File.dirname(__FILE__) + '/spec_helper'

describe Clicktale do
  describe "controller methods" do
    # Object.send(:remove_const, :MockController) rescue nil
    # class MockClicktalesController < ApplicationController
    #   include Clicktale::Controller
    # end
    # controller_name :mock_clicktales
  end

  describe "helper methods" do
    
  end

  describe "routing" do
    it "should route /clicktales/:id to the clicktales controller show action" do
      ActionController::Routing::Routes.draw { |map| map.clicktales }
      routes = ActionController::Routing::Routes
      routes.recognize_path("/clicktales/foo").should == { :controller => "clicktales", :action => "show", :id => "foo" }
    end
  end
end