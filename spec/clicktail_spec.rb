require File.dirname(__FILE__) + '/spec_helper'

describe Clicktale do
  describe "controller" do
  end

  describe "helper" do
  end

  describe "routing" do
    it "should route /clicktales/:id to the clicktales controller show action" do
      pending
      ActionController::Routing::Routes.draw { |map| map.clicktales }
      assert_routing("/clicktales/foo", { :controller => "clicktales", :action => "show" })
    end
  end
end