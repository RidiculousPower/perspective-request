
require 'cascading-configuration-array-sorted-unique'

require_relative '../../path/lib/magnets-path.rb'

module ::Magnets
  class Request
    module Interface
    end
    module Match
      module Host
      end
      module IP
      end
      module Method
      end
      module Port
      end
      module Referer
      end
      module URISchema
      end
      module UserAgent
      end
    end
  end
end

basepath = 'magnets-request/Magnets/Request'

files = [
  'Interface',
  'Match/Host',
  'Match/IP',
  'Match/Method',
  'Match/Port',
  'Match/Referer',
  'Match/URISchema',
  'Match/UserAgent',
  'Rack'
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )

::Magnets.extend( ::Magnets::Request::Rack )