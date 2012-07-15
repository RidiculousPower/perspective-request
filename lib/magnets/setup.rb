
::Magnets.extend( ::Magnets::Request::RackApplication )  

::Magnets::Configuration.register_configuration( :request, ::Magnets::Request::Configuration )

class ::Magnets::Path
  include ::Magnets::Request::Path
end
