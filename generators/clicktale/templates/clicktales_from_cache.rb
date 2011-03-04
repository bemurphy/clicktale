class ClicktalesFromCache
  attr_reader :app, :cache
  
  BASE_PATH = "/clicktales/"

  def initialize(app, cache)
    @app = app
    @cache = cache
  end
  
  def call(env)
    @request_uri = env["REQUEST_URI"]
    if clicktales_request?
      if cached_page = cache.read(clicktale_id)
        cache.delete(clicktale_id)
        [200, { 'Content-Type' => "text/html;" }, cached_page]
      else
        [404, { 'Content-Type' => "text/plain;" }, ["Can't find that id\n"]]
      end
    else
      app.call(env)
    end
  end
  
  protected
  
  def clicktales_request?
    @request_uri && @request_uri.index(BASE_PATH) == 0
  end
  
  def clicktale_id
    @request_uri.match(%r{^#{BASE_PATH}([A-Fa-z0-9]+)})[1]
  end
end