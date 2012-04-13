
module ::Magnets::Request::Interface
  
  include ::CascadingConfiguration::Array::Sorted::Unique

	################
  #  initialize  #
  ################
  
  def initialize( rack_request )
    
    @rack_request = rack_request
    
    @request_path = ::Magnets::Path::RequestPath.new( rack_request.path_info )
    
  end

	##################
	#  rack_request  #
  #  request_path  #
  ##################

  attr_reader :rack_request, :request_path
  
	##########
  #  path  #
  ##########
  
  alias_method :path, :request_path
  
	################
  #  uri_schema  #
  ################

  # http, https, etc.
  # 
  attr_configuration_sorted_unique_array :uri_schema do
		
		#=================#
    #  pre_set_hooks  #
		#=================#
  	
		def pre_set_hooks( index, uri_schema, is_insert )
		  
		  uri_schema = uri_schema.to_s
		  
		  # strip ://
		  schema_end_delimiter_range = -3..-1
		  if uri_schema.slice( schema_end_delimiter_range ) == '://'
		    uri_schema.slice!( schema_end_delimiter_range )
	    end
		  
		  return uri_schema.to_sym
		  
		end
		
  end

	####################
  #  request_method  #
  ####################
  
  # GET, PUT, POST, DELETE
  #
  attr_configuration_sorted_unique_array :request_method do
		
		#=================#
    #  pre_set_hooks  #
		#=================#
  	
		def pre_set_hooks( index, request_method, is_insert )
		  
		  case request_method
		    
  	    when :GET, :PUT, :POST, :DELETE
	      
  	      # nothing to do
	      
        else
		    
  		    request_method = request_method.to_s.upcase.to_sym
		    
  		    case request_method
		      
    	    when :GET, :PUT, :POST, :DELETE
		      
    	      # nothing to do

  	      else
		      
  		      raise ::ArgumentError, 
  		            'Expected :GET, :PUT, :POST, or :DELETE, but received :' + 
  		            request_method.to_s + '.'
		      
  	      end
		    
	    end
		  
		  return request_method
		  
	  end
		
		#=======#
    #  get  #
    #=======#

    def get

  		push( :GET )

  		return self

    end

  	#=============#
    #  minus_get  #
    #=============#

    def minus_get
      
      delete_method( :GET )

  		return self
  		
    end

  	#=======#
    #  put  #
    #=======#

    def put

  		push( :PUT )

  		return self

    end

  	#=============#
    #  minus_put  #
    #=============#

    def minus_put
      
      delete_method( :PUT )

  		return self
  		
    end

  	#========#
    #  post  #
    #========#

    def post

  		push( :POST )

  		return self

    end

  	#==============#
    #  minus_post  #
    #==============#

    def minus_post
      
      delete_method( :POST )

  		return self
  		
    end

  	#=================#
    #  delete_method  #
  	#=================#

    alias_method :delete_method, :delete

  	#==========#
    #  delete  #
    #==========#
    
    def delete

  		push( :DELETE )

  		return self

    end		
		
		#================#
    #  minus_delete  #
    #================#
  	
  	def minus_delete
      
      delete_method( :DELETE )

  		return self
  		
    end
    
  end

	##########
  #  host  #
  ##########

  def host( *hosts )
		
		hosts.push( *hosts )
		
		return self
		
  end
	alias_method :hostname, :host

	###########
  #  hosts  #
  ###########

  attr_configuration_sorted_unique_array :hosts

	########
  #  ip  #
  ########

  def ip( *ips )
		
		ips.push( *ips )
		
		return self
		
  end

	#########
  #  ips  #
  #########

  attr_configuration_sorted_unique_array :ips
	
	##########
  #  port  #
  ##########

  def port( *ports )
		
		ports.push( *ports )
		
		return self
		
  end

	###########
  #  ports  #
  ###########

  attr_configuration_sorted_unique_array :ports

	#############
  #  referer  #
  #############

  def referer( *referers )
		
		referers.push( *referers )

		return self
		
  end

	##############
  #  referers  #
  ##############

  attr_configuration_sorted_unique_array :referers
	
	################
  #  user_agent  #
  ################

  def user_agent( *user_agents )
		
		user_agents.push( *user_agents )
		
		return self
		
  end
  
	#################
  #  user_agents  #
  #################

  attr_configuration_sorted_unique_array :user_agents
  
end
