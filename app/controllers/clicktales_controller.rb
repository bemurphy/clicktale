class ClicktalesController < ApplicationController
  def show
    page = Rails.cache.read(params[:id])
    if page.blank?
      # TODO
    else
      render :text => page, :content_type => "text/html", :layout => false
    end
  end
end