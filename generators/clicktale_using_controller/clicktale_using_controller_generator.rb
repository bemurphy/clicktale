class ClicktaleUsingControllerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.template('WRb.js', "public/javascripts/WRb.js")
      m.template('clicktale.yml', "config/clicktale.yml")
      
      m.template('clicktales_controller.rb', 'app/controllers/clicktales_controller.rb')
    end
  end
end