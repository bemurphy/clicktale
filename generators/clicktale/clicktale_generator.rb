class ClicktaleGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # m.template('clicktales_controller.rb', 'app/controllers/clicktales_controller.rb')
      m.directory 'app/middlewares'
      m.template('clicktales_from_cache.rb', 'app/middlewares/clicktales_from_cache.rb')
      m.template('clicktale.yml', "config/clicktale.yml")
      m.template('WRb.js', "public/javascripts/WRb.js")
    end
  end
end