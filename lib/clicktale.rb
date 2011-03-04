require 'clicktale/controller'
require 'clicktale/helper'
require 'clicktale/routing'

module Clicktale

  def self.init
    ActionController::Base.append_view_path(File.dirname(__FILE__) + "/../../app/views") if ActionController::Base.respond_to?(:append_view_path)
    ActionView::Base.send(:include, Clicktale::Helper)
  end

  CONFIG = HashWithIndifferentAccess.new
  begin
    conffile = File.join(RAILS_ROOT, "config", "clicktale.yml")
    conf = YAML.load(File.read(conffile))
    CONFIG.merge!(conf[RAILS_ENV])
  rescue
    puts "*" * 50
    puts "#{conffile} can not be loaded, you should probably run the generator:"
    puts $!
    puts "*" * 50
  end

end
