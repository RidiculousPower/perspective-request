
module ::Magnets::Request::Interface
  
  include ::CascadingConfiguration::Array::Sorted::Unique

	################
  #  initialize  #
  ################
  
  def initialize( rack_request )
    
    @rack_request = rack_request
    
    @request_path = ::Magnets::Path::RequestPath.new( rack_request.path_info )
    
  end
  
  ####################
  #  raw_parameters  #
  ####################
  
  def raw_parameters

		return @rack_request.params
		
  end
	
	################
	#  parameters  #
  ################

  alias_method :parameters, :raw_parameters

	##################
	#  rack_request  #
  ##################

  attr_reader :rack_request
  
	##################
  #  request_path  #
  #  path          #
  ##################
  
  attr_reader  :request_path
  alias_method :path, :request_path
  
  ################
  #  uri_schema  #
  ################

  # http, https, etc.
  # 
  def uri_schema
		
		return @rack_request.uri_schema
		
  end

	####################
  #  request_method  #
  ####################
  
  # GET, PUT, POST, DELETE
  #
  def request_method
		
		return @rack_request.request_method
		
  end

	##########
  #  get?  #
  ##########
  
  def get?

		return @rack_request.get?

  end

	##########
  #  put?  #
  ##########
  
  def put?

		return @rack_request.put?

  end

	###########
  #  post?  #
  ###########

  def post?
    
		return @rack_request.post?

  end

	#############
  #  delete?  #
  #############
  
  def delete?

		return @rack_request.delete?

  end

	##########
  #  host  #
  ##########

  def host
		
		return @rack_request.host
		
  end
	alias_method :hostname, :host

	########
  #  ip  #
  ########

  def ip
		
		return @rack_request.ip
		
  end
	
	##########
  #  port  #
  ##########

  def port
		
		return @rack_request.port
		
  end

	#############
  #  referer  #
  #############

  def referer
		
		return @rack_request.referer

  end
	alias_method :referrer, :referer

	################
  #  user_agent  #
  ################

  def user_agent
		
		return @rack_request.user_agent
		
  end
  	
end
