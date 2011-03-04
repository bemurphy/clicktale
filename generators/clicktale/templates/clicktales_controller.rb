class ClicktalesController < ApplicationController
  # If you want to restrict to clicktale ips, write a before filter and check
  # http headers per your architecture.
  
  before_filter :require_clicktale_user_agent
  
  def show
    page = Rails.cache.read(params[:id])
    if page.blank?
      render :text => "We're sorry, can't find that id", :status => 404
    else
      # purge the cache after the fetch to reduce space as well, plus for better security
      Rails.cache.delete(params[:id])
      render :text => page, :content_type => "text/html", :layout => false
    end
  end
  
  protected
  
  def require_clicktale_user_agent
    if Rails.env.production? && request.env["HTTP_USER_AGENT"] !~ /clickbot/i
      render :text => "Sorry, you're not authorized to view this page", :status => 403
    end
  end
end