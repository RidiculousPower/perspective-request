
require_relative '../../../lib/magnets-path.rb'

describe ::Magnets::Request do

	#############################
  #  initialize               #
  #  path_fragments_for_path  #
  #############################
  
  it 'can produce an array of path fragments from a path' do
    
    rack_request = nil
    rack_application = lambda do |environment|
    	rack_request = ::Rack::Request.new( environment )
      return ::Rack::Response.new(	'body text', 200, 'Content-Type' => 'text/html' ).finish
    end
    
    mock_request = ::Rack::MockRequest.new( rack_application ).get( 'http://somedomain.com/path/to/somewhere' )
    request = ::Magnets::Request.new( rack_request )
    request.instance_variable_get( :@path_fragments ).should == [ 'path', 'to', 'somewhere' ]

    mock_request = ::Rack::MockRequest.new( rack_application ).get( '/path/to/somewhere' )
    request = ::Magnets::Request.new( rack_request )
    request.instance_variable_get( :@path_fragments ).should == [ 'path', 'to', 'somewhere' ]

    mock_request = ::Rack::MockRequest.new( rack_application ).get( '/path/to/somewhere/' )
    request = ::Magnets::Request.new( rack_request )
    request.instance_variable_get( :@path_fragments ).should == [ 'path', 'to', 'somewhere' ]
    

  end

	##########
  #  name  #
  ##########

  it 'requires a name be specified for later short-hand/programmatic access' do
    ::Magnets::Path.new( :name ).name.should == :name
  end

	############
  #  scheme  #
  ############

  it 'can specify a scheme (ie. http, https); default is http' do
    ::Magnets::Path.new( :name ).instance_eval do
      schemes.include?( 'http' )
      scheme( 'https' )
      schemes.include?( 'https' )
    end
  end

	####################
  #  request_method  #
  ####################

  it 'can specify one or more schemes (ie. GET/PUT/POST/DELETE); default is [ GET, PUT, POST, DELETE ]' do
    ::Magnets::Path.new( :name ).instance_eval do
      request_methods.include?( :GET ).should == false
      request_methods.include?( :PUT ).should == false
      request_methods.include?( :POST ).should == false
      request_methods.include?( :DELETE ).should == false

      request_method( :GET )
      request_methods.include?( :GET ).should == true
      request_methods.should == [ :GET ]
      request_methods.delete( :GET )
      request_methods.include?( :GET ).should == false
      request_method( :get )
      request_methods.include?( :GET ).should == true
      request_methods.should == [ :GET ]

      request_method( :PUT )
      request_methods.include?( :PUT ).should == true
      request_methods.should == [ :GET, :PUT ]
      request_methods.delete( :PUT )
      request_methods.include?( :PUT ).should == false
      request_method( :put )
      request_methods.include?( :PUT ).should == true
      request_methods.should == [ :GET, :PUT ]

      request_method( :POST )
      request_methods.include?( :POST ).should == true
      request_methods.should == [ :GET, :PUT, :POST ]
      request_methods.delete( :POST )
      request_methods.include?( :POST ).should == false
      request_method( :post )
      request_methods.include?( :POST ).should == true
      request_methods.should == [ :GET, :PUT, :POST ]

      request_method( :DELETE )
      request_methods.include?( :DELETE ).should == true
      request_methods.should == [ :GET, :PUT, :POST, :DELETE ]
      request_methods.delete( :DELETE )
      request_methods.include?( :DELETE ).should == false
      request_method( :delete )
      request_methods.include?( :DELETE ).should == true
      request_methods.should == [ :GET, :PUT, :POST, :DELETE ]

      request_method( [ :GET, :PUT ] )
      request_methods.should == [ :GET, :PUT ]

      request_method( [ :POST, :PUT ] )
      request_methods.should == [ :POST, :PUT ]

    end
  end

	#########
  #  get  #
  #########

  it 'can specify GET' do
    ::Magnets::Path.new( :name ).get.request_methods.should == [ :GET ]
  end

	#########
  #  put  #
  #########

  it 'can specify PUT' do
    ::Magnets::Path.new( :name ).put.request_methods.should == [ :PUT ]
  end

	##########
  #  post  #
  ##########

  it 'can specify POST' do
    ::Magnets::Path.new( :name ).post.request_methods.should == [ :POST ]
  end

	############
  #  delete  #
  ############

  it 'can specify DELETE' do
    ::Magnets::Path.new( :name ).delete.request_methods.should == [ :DELETE ]
  end

	###########################
  #  delete_request_method  #
  ###########################

  it 'can remove a method that has previously been permitted' do
    ::Magnets::Path.new( :name ).instance_eval do
      request_methods.should == []
      request_method( :PUT )
      request_methods.should == [ :PUT ]
      delete_request_method( :PUT )
      request_methods.should == []
      request_method( :PUT )
      request_methods.should == [ :PUT ]
      delete_request_method( :put )
      request_methods.should == []
    end
  end
  
	##############
  #  host      #
  #  hostname  #
  ##############

  it 'can specify a hostname; hostnames and IPs are additive, not exclusive; default matches any hostname' do
    ::Magnets::Path.new( :name ).instance_eval do
      hosts.should == []
      host( 'somedomain.com' )
      hosts.should == [ 'somedomain.com' ]
      method( :host ).should == method( :hostname )
    end
  end

	########
  #  ip  #
  ########

  it 'can specify an IP address; IPs and hostnames are additive, not exclusive; default matches any IP' do
    ::Magnets::Path.new( :name ).instance_eval do
      ips.should == []
      ip( '10.0.0.1' )
      ips.should == [ '10.0.0.1' ]
      method( :ip ).should == method( :address )
    end    
  end

	##########
  #  port  #
  ##########

  it 'can specify one or more ports; default matches any port' do
    ::Magnets::Path.new( :name ).instance_eval do
      ports.should == []
      port( 80 )
      ports.should == [ 80 ]
    end    
  end

	#############
  #  referer  #
  #############

  it 'can specify a referer; default matches any referer' do
    ::Magnets::Path.new( :name ).instance_eval do
      referers.should == []
      view_path = ::Magnets::Path.new( :referer )
      referer( view_path )
      referers.should == [ view_path ]
    end
  end

	################
  #  user_agent  #
  ################

  it 'can specify a user-agent; default matches any user-agent' do
    ::Magnets::Path.new( :name ).instance_eval do
      user_agents.should == []
      user_agent( 'some_agent' )
      user_agents.should == [ 'some_agent' ]
    end
  end

	##############
  #  basepath  #
  ##############

  it 'can declare an additional basepath for matching viewpath routes (no default basepath)' do
    ::Magnets::Path.new( :name ).instance_eval do
      basepaths.is_a?( Array ).should == true
      basepaths.empty?.should == true
      basepath( 'root', :some_path )
      basepaths[ 0 ].is_a?( Array ).should == true
      basepaths[ 0 ][ 0 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
      basepaths[ 0 ][ 1 ].is_a?( ::Magnets::Path::PathPart::Variable ).should == true
    end
  end
	
	##########
  #  path  #
  ##########

  it 'can declare an additional path (no default path)' do
    ::Magnets::Path.new( :name ).instance_eval do
      paths.is_a?( Array ).should == true
      paths.empty?.should == true
      path( 'root', :some_path )
      paths[ 0 ].is_a?( Array ).should == true
      paths[ 0 ][ 0 ].is_a?( ::Magnets::Path::PathPart::Constant ).should == true
      paths[ 0 ][ 1 ].is_a?( ::Magnets::Path::PathPart::Variable ).should == true
    end
  end
	
	##########
  #  view  #
  ##########

  it 'can declare a view to be rendered to the document stack' do
    ::Magnets::Path.new( :name ).instance_eval do
      render_stack.is_a?( Array ).should == true
      render_stack.empty?.should == true
      configuration_block = Proc.new do |viewpath, view|
        puts 'viewpath configuration space'
      end
      view( ::Magnets::Path, & configuration_block ) 
      render_stack[ 0 ].is_a?( ::Magnets::Path::RenderStackViewStruct ).should == true
      render_stack[ 0 ][ :view_class ].should == ::Magnets::Path
      render_stack[ 0 ][ :configuration_proc ].should == configuration_block
    end
  end

	##################
  #  match_scheme  #
  ##################

  it 'can match declared scheme vs. request scheme' do
    ::Magnets::Path.new( :name ).instance_eval do
      match_scheme( 'http' ).should == true
      scheme( 'https' )
      match_scheme( 'https' ).should == true
      match_scheme( 'http' ).should == false
      scheme( 'http' )
      match_scheme( 'http' ).should == true
    end
  end
	
	##################
  #  match_method  #
  ##################

  it 'can match method scheme vs. request method' do
    ::Magnets::Path.new( :name ).instance_eval do

      request_request_method( :GET ).should == true
      request_request_method( :PUT ).should == true
      request_request_method( :POST ).should == true
      request_request_method( :DELETE ).should == true

      request_method( :GET )
      request_request_method( :GET ).should == true
      request_request_method( :PUT ).should == false
      request_request_method( :POST ).should == false
      request_request_method( :DELETE ).should == false

      request_method( :PUT )
      request_request_method( :GET ).should == true
      request_request_method( :PUT ).should == true
      request_request_method( :POST ).should == false
      request_request_method( :DELETE ).should == false

      request_method( :POST )
      request_request_method( :GET ).should == true
      request_request_method( :PUT ).should == true
      request_request_method( :POST ).should == true
      request_request_method( :DELETE ).should == false

      request_method( :DELETE )
      request_request_method( :GET ).should == true
      request_request_method( :PUT ).should == true
      request_request_method( :POST ).should == true
      request_request_method( :DELETE ).should == true

    end    
  end

	################
  #  match_host  #
  ################

  it 'can match declared host vs. request host' do
    ::Magnets::Path.new( :name ).instance_eval do
      match_host( 'anyhost.com' ).should == true
      host( 'somehost.com' )
      match_host( 'anyhost.com' ).should == false
      match_host( 'somehost.com' ).should == true
      host( 'anotherhost.com' )
      match_host( 'anotherhost.com' ).should == true
    end
  end

	##############
  #  match_ip  #
  ##############

  it 'can match declared IP vs. request IP' do
    ::Magnets::Path.new( :name ).instance_eval do
      match_ip( '10.0.0.1' ).should == true
      ip( '10.0.0.2' )
      match_ip( '10.0.0.1' ).should == false
      match_ip( '10.0.0.2' ).should == true
      ip( '10.0.0.3' )
      match_ip( '10.0.0.3' ).should == true
    end
  end

	################
  #  match_port  #
  ################

  it 'can match declared port vs. request port' do
    ::Magnets::Path.new( :name ).instance_eval do
      match_port( 80 ).should == true
      port( 81 )
      match_port( 80 ).should == false
      match_port( 81 ).should == true
      port( 80 )
      match_port( 80 ).should == true
    end
  end

	###################
  #  match_referer  #
  ###################

  it 'can match declared referer vs. request referer' do
    pending 'ensure format processing of referer'
    ::Magnets::Path.new( :name ).instance_eval do
      match_referer( ::Magnets::Path.new( :referer_path ) ).should == true
      referer( ::Magnets::Path.new( :referer_path ).host( 'some_host.com' ).path( 'some_path' ) )
      match_referer( 'other_host.com/some_path' ).should == false
      match_referer( 'some_host.com/some_path' ).should == true
      referer( ::Magnets::Path.new( :referer_path ).host( 'other_host.com' ).path( 'some_path' ) )
      match_referer( 'other_host.com/some_path' ).should == true
    end
  end

	######################
  #  match_user_agent  #
  ######################

  it 'can match declared user-agent vs. request user-agent' do
    pending 'not very important; write/ensure later'
  end
	
	#############################
  #  match  #
  #############################

  it 'can match all of the non-path elements at once' do
    pending 'works implicitly, write test later'
  end

  ###########################
  #  match_path_descriptor  #
  ###########################

  it 'can match against a single declared path' do
    ::Magnets::Path.new( :name ).instance_eval do

      # constant
      constant_part  = 'some_path'.extend( ::Magnets::Path::PathPart::Constant )
      descriptors    = [ constant_part ]
      path_parts     = [ 'some_path' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'some_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil

      # multipath constant
      constant_part  = 'some_path'.extend( ::Magnets::Path::PathPart::Constant )
      other_constant_part  = 'other_path'.extend( ::Magnets::Path::PathPart::Constant )
      descriptors    = [ constant_part, other_constant_part ]
      path_parts     = [ 'some_path', 'other_path' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'some_path', 'other_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'other_path', 'non_matching_path' ]
      match_path_descriptor( descriptors, non_matching_path ).should == nil

      # variable
      variable_part  = ::Magnets::Path::PathPart::Variable.new( :any_path )
      descriptors    = [ variable_part ]
      path_parts     = [ 'anything' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'anything' ]

      # regexp
      regexp_part  = Regexp.new( 'some_regexp(\d*)' ).extend( ::Magnets::Path::PathPart::Regexp )
      descriptors    = [ regexp_part ]
      path_parts     = [ 'some_regexp12' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12' ]
      path_parts     = [ 'some_regexp37' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp37' ]
      path_parts     = [ 'some_regexp' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp' ]
      path_parts     = [ 'not_some_regexp' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil
      path_parts     = [ 'not_some_regexp13' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # any path
      any_part  = '*'.extend( ::Magnets::Path::PathPart::Wildcard )
      descriptors    = [ any_part ]
      path_parts     = [ 'anything', 'any', 'other', 'part', 'as', 'well' ]
      match_path_descriptor( descriptors, path_parts ).should == [ 'anything', 'any', 'other', 'part', 'as', 'well' ]

      # constant, variable, regexp
      descriptors    = [ constant_part, variable_part, regexp_part ]
      path_parts     = [ 'some_path', 'anything', 'some_regexp12' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'anything', 'some_regexp12' ]
      non_matching_path   = [ 'some_path', 'anything', 'some_regexp12', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, regexp, variable
      descriptors    = [ constant_part, regexp_part, variable_part ]
      path_parts     = [ 'some_path', 'some_regexp12', 'anything' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'some_regexp12', 'anything' ]
      non_matching_path   = [ 'some_path', 'some_regexp12', 'anything', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil
      
      # variable, constant, regexp
      descriptors    = [ variable_part, constant_part, regexp_part ]
      path_parts     = [ 'anything', 'some_path', 'some_regexp12' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_path', 'some_regexp12' ]
      non_matching_path   = [ 'anything', 'some_path', 'some_regexp12', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # variable, regexp, constant
      descriptors    = [ variable_part, regexp_part, constant_part ]
      path_parts     = [ 'anything', 'some_regexp12', 'some_path' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_regexp12', 'some_path' ]
      non_matching_path   = [ 'anything', 'some_regexp12', 'some_path', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil
      
      # regexp, constant, variable
      descriptors    = [ regexp_part, constant_part, variable_part ]
      path_parts     = [ 'some_regexp12', 'some_path', 'anything' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'some_path', 'anything' ]
      non_matching_path   = [ 'some_regexp12', 'some_path', 'anything', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

      # regexp, variable, constant
      descriptors    = [ regexp_part, variable_part, constant_part ]
      path_parts     = [ 'some_regexp12', 'anything', 'some_path' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'anything', 'some_path' ]
      non_matching_path   = [ 'some_regexp12', 'anything', 'some_path', 'moar' ]
      match_path_descriptor( descriptors.dup, path_parts ).should == nil

    end
  end
	
  #################
  #  match_paths  #
  #################

  it 'can match the request path against all declared paths' do
    ::Magnets::Path.new( :name ).instance_eval do
      # no path
      path( '' )
      match_paths( '' ).should == [ '/' ]
      match_paths( 'some_path/other_path' ).should == nil
      match_paths( 'other_path' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant
      path( 'some_path' )
      match_paths( 'some_path' ).should == [ 'some_path' ]
      match_paths( 'some_path/other_path' ).should == nil
      match_paths( 'other_path' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # multipath constant
      path( 'some_path/other_path' )
      match_paths( 'some_path/other_path' ).should == [ 'some_path', 'other_path' ]
      match_paths( '/some_path/other_path' ).should == [ 'some_path', 'other_path' ]
      match_paths( 'some_path/other_path/another_path' ).should == nil
      match_paths( 'some_path' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable
      path( :random_path )
      match_paths( 'anything' ).should == [ 'anything' ]
      match_paths( '/anything' ).should == [ 'anything' ]
      match_paths( 'anything/another_path' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp
      path( /some_regexp(\d*)/ )
      match_paths( 'some_regexp42' ).should == [ 'some_regexp42' ]
      match_paths( '/some_regexp42' ).should == [ 'some_regexp42' ]
      match_paths( 'some_regexp42/other_path' ).should == nil
      match_paths( 'other_path' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # any path
      path( '*' )
      match_paths( 'some_regexp42' ).should == [ 'some_regexp42' ]
      match_paths( '/some_regexp42' ).should == [ 'some_regexp42' ]
      match_paths( 'some_regexp42/other_path' ).should == [ 'some_regexp42', 'other_path' ]
      match_paths( 'other_path' ).should == [ 'other_path' ]
      match_paths( '' ).should == [ '/' ]
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # any path ending
      path( 'some_path*' )
      match_paths( 'some_path/some_regexp42' ).should == [ 'some_path', 'some_regexp42' ]
      match_paths( 'some_path/some_regexp42' ).should == [ 'some_path', 'some_regexp42' ]
      match_paths( 'some_path/some_regexp42/other_path' ).should == [ 'some_path', 'some_regexp42', 'other_path' ]
      match_paths( 'some_path/other_path' ).should == [ 'some_path', 'other_path' ]
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant, variable, regexp
      path( 'some_path', :random_path, /some_regexp(\d*)/ )
      match_paths( 'some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_paths( '/some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_paths( 'some_path/other_path/not_regexp' ).should == nil
      match_paths( 'other_path/not_regexp' ).should == nil
      match_paths( 'other_path/not_regexp/some_regexp' ).should == nil
      match_paths( 'other_path/not_regexp/something_else' ).should == nil
      match_paths( 'some_path' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant, regexp, variable
      path( 'some_path', /some_regexp(\d*)/, :random_path )
      match_paths( 'some_path/some_regexp42/anything' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_paths( '/some_path/some_regexp42/anything' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_paths( 'some_path/some_regexp42/anything/something_else' ).should == nil
      match_paths( 'some_path/some_regexp42' ).should == nil
      match_paths( 'some_path' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable, constant, regexp
      path( :random_path, 'some_path', /some_regexp(\d*)/ )
      match_paths( 'anything/some_path/some_regexp42' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_paths( '/anything/some_path/some_regexp42' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_paths( 'anything/some_path/some_regexp42/something_else' ).should == nil
      match_paths( 'anything/some_path/something_else' ).should == nil
      match_paths( 'anything/something_else' ).should == nil
      match_paths( 'anything/some_path' ).should == nil
      match_paths( 'anything' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable, regexp, constant
      path( :random_path, /some_regexp(\d*)/, 'some_path' )
      match_paths( 'anything/some_regexp42/some_path' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_paths( 'anything/some_regexp42/some_path/something_else' ).should == nil
      match_paths( 'anything/some_regexp42' ).should == nil
      match_paths( 'anything/some_path' ).should == nil
      match_paths( 'anything/something_else' ).should == nil
      match_paths( 'anything' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp, constant, variable
      path( /some_regexp(\d*)/, 'some_path', :random_path )
      match_paths( 'some_regexp42/some_path/anything' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_paths( '/some_regexp42/some_path/anything' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_paths( 'some_regexp42/some_path/anything/something_else' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( 'some_path/anything' ).should == nil
      match_paths( 'something_else/anything' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp, variable, constant
      path( /some_regexp(\d*)/, :random_path, 'some_path' )
      match_paths( 'some_regexp42/anything/some_path' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_paths( '/some_regexp42/anything/some_path' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_paths( 'some_regexp42/anything/some_path/something_else' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( 'some_path/anything' ).should == nil
      match_paths( 'something_else/anything' ).should == nil
      match_paths( 'some_regexp42/anything' ).should == nil
      match_paths( '' ).should == nil
    end
  end
	
	###############################
  #  match_basepath_descriptor  #
  ###############################

  it 'can match against a single declared basepath' do
    ::Magnets::Path.new( :name ).instance_eval do
    
      # constant
      constant_part  = 'some_path'.extend( ::Magnets::Path::PathPart::Constant )
      descriptors    = [ constant_part ]
      path_parts     = [ 'some_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors, path_parts ).should == [ 'some_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil

      # multipath constant
      constant_part  = 'some_path'.extend( ::Magnets::Path::PathPart::Constant )
      other_constant_part  = 'other_path'.extend( ::Magnets::Path::PathPart::Constant )
      descriptors    = [ constant_part, other_constant_part ]
      path_parts     = [ 'some_path', 'other_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors, path_parts ).should == [ 'some_path', 'other_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'other_path', 'non_matching_path' ]
      match_basepath_descriptor( descriptors, non_matching_path ).should == nil

      # variable
      variable_part  = ::Magnets::Path::PathPart::Variable.new( :any_path )
      descriptors    = [ variable_part ]
      path_parts     = [ 'anything' ]
      match_basepath_descriptor( descriptors, path_parts ).should == [ 'anything' ]

      # regexp
      regexp_part  = Regexp.new( 'some_regexp(\d*)' ).extend( ::Magnets::Path::PathPart::Regexp )
      descriptors    = [ regexp_part ]
      path_parts     = [ 'some_regexp12', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12' ]
      path_parts     = [ 'some_regexp37' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp37' ]
      path_parts     = [ 'some_regexp' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp' ]
      path_parts     = [ 'not_some_regexp' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
      path_parts     = [ 'not_some_regexp13' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, variable, regexp
      descriptors    = [ constant_part, variable_part, regexp_part ]
      path_parts     = [ 'some_path', 'anything', 'some_regexp12', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'anything', 'some_regexp12' ]
      non_matching_path   = [ 'some_path', 'anything', 'some_regexp12', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, regexp, variable
      descriptors    = [ constant_part, regexp_part, variable_part ]
      path_parts     = [ 'some_path', 'some_regexp12', 'anything', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'some_regexp12', 'anything' ]
      non_matching_path   = [ 'some_path', 'some_regexp12', 'anything', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
    
      # variable, constant, regexp
      descriptors    = [ variable_part, constant_part, regexp_part ]
      path_parts     = [ 'anything', 'some_path', 'some_regexp12', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_path', 'some_regexp12' ]
      non_matching_path   = [ 'anything', 'some_path', 'some_regexp12', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # variable, regexp, constant
      descriptors    = [ variable_part, regexp_part, constant_part ]
      path_parts     = [ 'anything', 'some_regexp12', 'some_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_regexp12', 'some_path' ]
      non_matching_path   = [ 'anything', 'some_regexp12', 'some_path', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
    
      # regexp, constant, variable
      descriptors    = [ regexp_part, constant_part, variable_part ]
      path_parts     = [ 'some_regexp12', 'some_path', 'anything', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'some_path', 'anything' ]
      non_matching_path   = [ 'some_regexp12', 'some_path', 'anything', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil

      # regexp, variable, constant
      descriptors    = [ regexp_part, variable_part, constant_part ]
      path_parts     = [ 'some_regexp12', 'anything', 'some_path', 'some_other_part', 'something_else' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'anything', 'some_path' ]
      non_matching_path   = [ 'some_regexp12', 'anything', 'some_path', 'moar' ]
      match_basepath_descriptor( descriptors.dup, path_parts ).should == nil
    
    end
    
  end
  
  #####################
  #  match_basepaths  #
  #####################

  it 'can match the request path against all declared base paths' do
    ::Magnets::Path.new( :name ).instance_eval do
      # constant
      basepath( 'some_path' )
      match_basepaths( 'some_path/some_other_part/something_else' ).should == [ 'some_path' ]
      match_basepaths( 'some_path/other_path' ).should == [ 'some_path' ]
      match_basepaths( 'other_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # multipath constant
      basepath( 'some_path/other_path' )
      match_basepaths( 'some_path/other_path/some_other_part/something_else' ).should == [ 'some_path', 'other_path' ]
      match_basepaths( 'some_path/another_path' ).should == nil
      match_basepaths( 'some_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable
      basepath( :random_path )
      match_basepaths( 'anything/some_other_part/something_else' ).should == [ 'anything' ]
      match_basepaths( 'anything/something_else' ).should == [ 'anything' ]
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp
      basepath( /some_regexp(\d*)/ )
      match_basepaths( 'some_regexp42/some_other_part/something_else' ).should == [ 'some_regexp42' ]
      match_basepaths( 'some_regexp42/other_path' ).should == [ 'some_regexp42' ]
      match_basepaths( 'other_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant, variable, regexp
      basepath( 'some_path', :random_path, /some_regexp(\d*)/ )
      match_basepaths( 'some_path/anything/some_regexp42/some_other_part/something_else' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_basepaths( 'some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_basepaths( 'other_path/not_regexp' ).should == nil
      match_basepaths( 'other_path/not_regexp/some_regexp' ).should == nil
      match_basepaths( 'other_path/not_regexp/something_else' ).should == nil
      match_basepaths( 'some_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant, regexp, variable
      basepath( 'some_path', /some_regexp(\d*)/, :random_path )
      match_basepaths( 'some_path/some_regexp42/anything/some_other_part/something_else' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_basepaths( 'some_path/some_regexp42/anything/something_else' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_basepaths( 'some_path/some_regexp42' ).should == nil
      match_basepaths( 'some_path' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable, constant, regexp
      basepath( :random_path, 'some_path', /some_regexp(\d*)/ )
      match_basepaths( 'anything/some_path/some_regexp42/some_other_part/something_else' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_basepaths( 'anything/some_path/some_regexp42/something_else' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_basepaths( 'anything/some_path/something_else' ).should == nil
      match_basepaths( 'anything/something_else' ).should == nil
      match_basepaths( 'anything/some_path' ).should == nil
      match_basepaths( 'anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable, regexp, constant
      basepath( :random_path, /some_regexp(\d*)/, 'some_path' )
      match_basepaths( 'anything/some_regexp42/some_path/some_other_part/something_else' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_basepaths( 'anything/some_regexp42/some_path/something_else' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_basepaths( 'anything/some_regexp42' ).should == nil
      match_basepaths( 'anything/some_path' ).should == nil
      match_basepaths( 'anything/something_else' ).should == nil
      match_basepaths( 'anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp, constant, variable
      basepath( /some_regexp(\d*)/, 'some_path', :random_path )
      match_basepaths( 'some_regexp42/some_path/anything/some_other_part/something_else' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_basepaths( 'some_regexp42/some_path/anything/something_else' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( 'some_path/anything' ).should == nil
      match_basepaths( 'something_else/anything' ).should == nil
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp, variable, constant
      basepath( /some_regexp(\d*)/, :random_path, 'some_path' )
      match_basepaths( 'some_regexp42/anything/some_path/some_other_part/something_else' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_basepaths( 'some_regexp42/anything/some_path/something_else' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( 'some_path/anything' ).should == nil
      match_basepaths( 'something_else/anything' ).should == nil
      match_basepaths( 'some_regexp42/anything' ).should == nil
      match_basepaths( '' ).should == nil
    end
  end

	###############################
  #  match_tailpath_descriptor  #
  ###############################

  it 'can match against a single declared tailpath' do
    ::Magnets::Path.new( :name ).instance_eval do
    
      # constant
      constant_part  = 'some_path'.extend( ::Magnets::Path::PathPart::Constant )
      descriptors    = [ constant_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_path' ]
      match_tailpath_descriptor( descriptors, path_parts ).should == [ 'some_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_tailpath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_tailpath_descriptor( descriptors, non_matching_path ).should == nil

      # multipath constant
      constant_part  = 'some_path'.extend( ::Magnets::Path::PathPart::Constant )
      other_constant_part  = 'other_path'.extend( ::Magnets::Path::PathPart::Constant )
      descriptors    = [ constant_part, other_constant_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_path', 'other_path' ]
      match_tailpath_descriptor( descriptors, path_parts ).should == [ 'some_path', 'other_path' ]
      non_matching_path   = [ 'non_matching_path' ]
      match_tailpath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'non_matching_path' ]
      match_tailpath_descriptor( descriptors, non_matching_path ).should == nil
      non_matching_path   = [ 'some_path', 'other_path', 'non_matching_path' ]
      match_tailpath_descriptor( descriptors, non_matching_path ).should == nil

      # variable
      variable_part  = ::Magnets::Path::PathPart::Variable.new( :any_path )
      descriptors    = [ variable_part ]
      path_parts     = [ 'anything' ]
      match_tailpath_descriptor( descriptors, path_parts ).should == [ 'anything' ]

      # regexp
      regexp_part  = Regexp.new( 'some_regexp(\d*)' ).extend( ::Magnets::Path::PathPart::Regexp )
      descriptors    = [ regexp_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_regexp12' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12' ]
      path_parts     = [ 'some_regexp37' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp37' ]
      path_parts     = [ 'some_regexp' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp' ]
      path_parts     = [ 'not_some_regexp' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == nil
      path_parts     = [ 'not_some_regexp13' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == nil

      # constant, variable, regexp
      descriptors    = [ constant_part, variable_part, regexp_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_path', 'anything', 'some_regexp12' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'anything', 'some_regexp12' ]
      non_matching_path   = [ 'some_path', 'anything', 'some_regexp12', 'moar' ]
      match_tailpath_descriptor( descriptors.dup, non_matching_path ).should == nil

      # constant, regexp, variable
      descriptors    = [ constant_part, regexp_part, variable_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_path', 'some_regexp12', 'anything' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_path', 'some_regexp12', 'anything' ]
      non_matching_path   = [ 'some_path', 'some_regexp12', 'anything', 'moar' ]
      match_tailpath_descriptor( descriptors.dup, non_matching_path ).should == nil
    
      # variable, constant, regexp
      descriptors    = [ variable_part, constant_part, regexp_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'anything', 'some_path', 'some_regexp12' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_path', 'some_regexp12' ]
      non_matching_path   = [ 'anything', 'some_path', 'some_regexp12', 'moar' ]
      match_tailpath_descriptor( descriptors.dup, non_matching_path ).should == nil

      # variable, regexp, constant
      descriptors    = [ variable_part, regexp_part, constant_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'anything', 'some_regexp12', 'some_path' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'anything', 'some_regexp12', 'some_path' ]
      non_matching_path   = [ 'anything', 'some_regexp12', 'some_path', 'moar' ]
      match_tailpath_descriptor( descriptors.dup, non_matching_path ).should == nil
    
      # regexp, constant, variable
      descriptors    = [ regexp_part, constant_part, variable_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_regexp12', 'some_path', 'anything' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'some_path', 'anything' ]
      non_matching_path   = [ 'some_regexp12', 'some_path', 'anything', 'moar' ]
      match_tailpath_descriptor( descriptors.dup, non_matching_path ).should == nil

      # regexp, variable, constant
      descriptors    = [ regexp_part, variable_part, constant_part ]
      path_parts     = [ 'some_other_part', 'something_else', 'some_regexp12', 'anything', 'some_path' ]
      match_tailpath_descriptor( descriptors.dup, path_parts ).should == [ 'some_regexp12', 'anything', 'some_path' ]
      non_matching_path   = [ 'some_regexp12', 'anything', 'some_path', 'moar' ]
      match_tailpath_descriptor( descriptors.dup, non_matching_path ).should == nil
    
    end
    
  end
  
  #####################
  #  match_tailpaths  #
  #####################

  it 'can match the request path against all declared base paths' do
    ::Magnets::Path.new( :name ).instance_eval do
      # constant
      tailpath( 'some_path' )
      match_tailpaths( 'some_other_part/something_else/some_path' ).should == [ 'some_path' ]
      match_tailpaths( 'other_path/some_path' ).should == [ 'some_path' ]
      match_tailpaths( 'other_path' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # multipath constant
      tailpath( 'some_path/other_path' )
      match_tailpaths( 'some_other_part/something_else/some_path/other_path' ).should == [ 'some_path', 'other_path' ]
      match_tailpaths( 'another_path/some_path' ).should == nil
      match_tailpaths( 'some_path' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable
      tailpath( :random_path )
      match_tailpaths( 'some_other_part/something_else/anything' ).should == [ 'anything' ]
      match_tailpaths( 'something_else/anything' ).should == [ 'anything' ]
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp
      tailpath( /some_regexp(\d*)/ )
      match_tailpaths( 'some_other_part/something_else/some_regexp42' ).should == [ 'some_regexp42' ]
      match_tailpaths( 'other_path/some_regexp42' ).should == [ 'some_regexp42' ]
      match_tailpaths( 'other_path' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant, variable, regexp
      tailpath( 'some_path', :random_path, /some_regexp(\d*)/ )
      match_tailpaths( '/some_other_part/something_else/some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_tailpaths( 'some_path/anything/some_regexp42' ).should == [ 'some_path', 'anything', 'some_regexp42' ]
      match_tailpaths( 'other_path/not_regexp' ).should == nil
      match_tailpaths( 'other_path/not_regexp/some_regexp' ).should == nil
      match_tailpaths( 'other_path/not_regexp/something_else' ).should == nil
      match_tailpaths( 'some_path' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # constant, regexp, variable
      tailpath( 'some_path', /some_regexp(\d*)/, :random_path )
      match_tailpaths( 'some_other_part/something_else/some_path/some_regexp42/anything' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_tailpaths( 'something_else/some_path/some_regexp42/anything' ).should == [ 'some_path', 'some_regexp42', 'anything' ]
      match_tailpaths( 'some_path/some_regexp42' ).should == nil
      match_tailpaths( 'some_path' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable, constant, regexp
      tailpath( :random_path, 'some_path', /some_regexp(\d*)/ )
      match_tailpaths( 'some_other_part/something_else/anything/some_path/some_regexp42' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_tailpaths( 'something_else/anything/some_path/some_regexp42' ).should == [ 'anything', 'some_path', 'some_regexp42' ]
      match_tailpaths( 'anything/some_path/something_else' ).should == nil
      match_tailpaths( 'anything/something_else' ).should == nil
      match_tailpaths( 'anything/some_path' ).should == nil
      match_tailpaths( 'anything' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # variable, regexp, constant
      tailpath( :random_path, /some_regexp(\d*)/, 'some_path' )
      match_tailpaths( 'some_other_part/something_else/anything/some_regexp42/some_path' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_tailpaths( 'something_else/anything/some_regexp42/some_path' ).should == [ 'anything', 'some_regexp42', 'some_path' ]
      match_tailpaths( 'anything/some_regexp42' ).should == nil
      match_tailpaths( 'anything/some_path' ).should == nil
      match_tailpaths( 'anything/something_else' ).should == nil
      match_tailpaths( 'anything' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp, constant, variable
      tailpath( /some_regexp(\d*)/, 'some_path', :random_path )
      match_tailpaths( 'some_other_part/something_else/some_regexp42/some_path/anything' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_tailpaths( 'something_else/some_regexp42/some_path/anything' ).should == [ 'some_regexp42', 'some_path', 'anything' ]
      match_tailpaths( 'some_regexp42/anything' ).should == nil
      match_tailpaths( 'some_path/anything' ).should == nil
      match_tailpaths( 'something_else/anything' ).should == nil
      match_tailpaths( 'some_regexp42/anything' ).should == nil
      match_tailpaths( '' ).should == nil
    end
    ::Magnets::Path.new( :name ).instance_eval do
      # regexp, variable, constant
      tailpath( /some_regexp(\d*)/, :random_path, 'some_path' )
      match_tailpaths( 'some_other_part/something_else/some_regexp42/anything/some_path' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_tailpaths( 'something_else/some_regexp42/anything/some_path' ).should == [ 'some_regexp42', 'anything', 'some_path' ]
      match_tailpaths( 'some_regexp42/anything' ).should == nil
      match_tailpaths( 'some_path/anything' ).should == nil
      match_tailpaths( 'something_else/anything' ).should == nil
      match_tailpaths( 'some_regexp42/anything' ).should == nil
      match_tailpaths( '' ).should == nil
    end
  end
  
end
