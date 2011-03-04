module Clicktale
  module Controller

    def self.included(base)
      base.class_eval do
        @@clicktale_options = {}
        around_filter :clicktaleize
        helper_method :clicktale_enabled?
        helper_method :clicktale_config
        helper_method :clicktale_path
        helper_method :clicktale_url
      end
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def clicktale(opts = {})
        @@clicktale_options = opts
      end
    end

    def clicktale(opts = {})
      @clicktale_options = opts
    end

    def clicktaleize
      yield
      if clicktale_enabled?
        begin
          Rails.cache.write(clicktale_cache_token, response.body, cache_write_options)
        rescue => e # Analytics should never take you down.
          logger.error("cache failed, returning yielded data and skipping cache: #{e}")
        end
      end
    end

    def clicktale_enabled?
      @clicktale_enabled ||= clicktale_config[:enabled] && request.format.html? && request.get?
    end

    def clicktale_config
      @clicktale_config ||= Clicktale::CONFIG.merge(@@clicktale_options || {}).merge(@clicktale_options || {})
    end
    
    protected

    def clicktale_cache_token
      @clicktale_cache_token ||= ActiveSupport::SecureRandom.hex(32)
    end

    def clicktale_url
      @clicktale_url ||= "#{request.protocol}#{request.host_with_port}#{clicktale_path}"
    end    

    def clicktale_path
      @clicktale_path ||= "/clicktales/#{clicktale_cache_token}"
    end


    def cache_write_options
      clicktale_config[:expires_in] ? { :expires_in => clicktale_config[:expires_in].to_i } : {}
    end
  end
end
