class ClicktaleUsingMiddlewareGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template('../../clicktale_using_controller/templates/WRb.js', "public/javascripts/WRb.js")
      m.template('../../clicktale_using_controller/templates/clicktale.yml', "config/clicktale.yml")
      
      m.directory 'app/middlewares'
      m.template('clicktales_from_cache.rb', 'app/middlewares/clicktales_from_cache.rb')
    end
  end
end