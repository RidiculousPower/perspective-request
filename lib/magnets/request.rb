
begin ; require 'development' ; rescue ::LoadError ; end

require 'magnets/path'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

# post-require setup
require_relative './setup.rb'

class ::Magnets::Request
  
  include ::Magnets::Request::Interface
  
  Headers = { } 
  
end
