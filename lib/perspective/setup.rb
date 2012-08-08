
::Perspective.extend( ::Perspective::Request::RackApplication )  

::Perspective::Configuration.register_configuration( :request, ::Perspective::Request::Configuration )

class ::Perspective::Request::Path
  include ::Perspective::Request::Path
end
