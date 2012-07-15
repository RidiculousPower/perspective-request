
module ::Magnets::Request::RackApplication

  attr_reader :request

  ##########
  #  call  #
  ##########

  def call( environment )
				
		return application.call( environment )
	
	end

	#################
  #  application  #
  #################
  
	def application
	  
	  return @application ||= lambda do |environment|

  	  @request = ::Magnets::Request.new( ::Rack::Request.new( environment ) )

  	  return rack_response

    end
	  
  end

  #############
  #  status   #
  #  status=  #
  #############

  attr_accessor :status

	##############
  #  redirect  #
  ##############

  def redirect( destination )
    
    @content = 'Redirecting!'
		@status = 301
		::Magnets::Request::Headers[ 'Location' ] = destination
        
    return self
        
  end

  ##########
  #  root  #
  ##########
  
  def root
    
    return ::Magnets::Configuration.request.root
    
  end

  ##############
  #  root=     #
  #  set_root  #
  ##############
  
  def root=( root_class )
    
    return ::Magnets::Configuration.request.root = root_class
    
  end
  alias_method  :set_root, :root=

  ###################
  #  root_instance  #
  ###################
  
  def root_instance
    
    return ::Magnets::Configuration.request.root_instance
    
  end

  #######################
  #  root_instance=     #
  #  set_root_instance  #
  #######################
  
  def root_instance=( root_instance )
    
    return ::Magnets::Configuration.request.root_instance = root_instance
    
  end
  alias_method  :set_root_instance, :root_instance=

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	###################
  #  rack_response  #
  ###################
  
  def rack_response
    
    initialize_headers
        
    initialize_status
		
		initialize_root
    
	  render_content
        
    return finish_response

  end
  
	########################
  #  initialize_headers  #
  ########################
  
  def initialize_headers
    
    ::Magnets::Request::Headers.clear
    
  end
  
	#####################
  #  initialize_root  #
  #####################
  
  def initialize_root
    
    self.root_instance = root.new
    
  end

	#######################
  #  initialize_status  #
  #######################
  
  def initialize_status
    
		::Magnets::Request::Headers[ 'Content-Type' ] = 'text/html'
		
		@status = 200
    
  end

  ####################
  #  render_content  #
  ####################
	
  def render_content
    
		return @content = root_instance.to_html
		
  end
  
  #####################
  #  finish_response  #
  #####################
	
  def finish_response
    
    return ::Rack::Response.new( @content, @status, ::Magnets::Request::Headers ).finish
    
  end
  
end
