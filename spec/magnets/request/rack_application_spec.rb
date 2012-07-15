
require_relative '../../../lib/magnets-request.rb'

require 'persistence'
require 'persistence-adapter-mock'

require 'rack/mock'

describe ::Magnets do

  before :all do
    class ::Magnets::Mock
      def to_html
        return 'Hello World!'
      end
    end
  end

  it 'test' do
    
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    ::Magnets.root = ::Magnets::Mock

    mock_request = ::Rack::MockRequest.new( ::Magnets )
    
    mock_response = mock_request.get( 'path/to/somewhere' )

    mock_response.body.should == "Hello World!"
    
  end

end