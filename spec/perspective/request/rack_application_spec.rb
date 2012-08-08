
require_relative '../../../lib/perspective/request.rb'

require 'persistence'

require 'rack/mock'

describe ::Perspective do

  before :all do
    class ::Perspective::Mock
      def to_html
        return 'Hello World!'
      end
    end
  end

  it 'test' do
    
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    ::Perspective.root = ::Perspective::Mock

    mock_request = ::Rack::MockRequest.new( ::Perspective )
    
    mock_response = mock_request.get( 'path/to/somewhere' )

    mock_response.body.should == "Hello World!"
    
  end

end