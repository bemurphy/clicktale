module Clicktale #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def clicktales
        @set.add_route("/clicktales/:id", {:controller => "clicktales", :action => "show"})
      end
    end
  end
end
 
ActionController::Routing::RouteSet::Mapper.send :include, Clicktale::Routing::MapperExtensions