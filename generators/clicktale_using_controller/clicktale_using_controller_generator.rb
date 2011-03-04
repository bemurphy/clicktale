class ClicktaleUsingControllerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template('WRb.js', "public/javascripts/WRb.js")
      m.template('clicktale.yml', "config/clicktale.yml")
      
      m.template('clicktales_controller.rb', 'app/controllers/clicktales_controller.rb')
      
      sentinel = 'ActionController::Routing::Routes.draw do |map|'
      mapping = "map.clicktales"
      logger.route mapping
      
      m.gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  #{mapping}\n"
      end
      
    end
  end
end