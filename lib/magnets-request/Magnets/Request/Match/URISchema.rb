
module ::Magnets::Request::Match::URISchema

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_uri_schema( request.uri_schema )

	end

	######################
  #  match_uri_schema  #
  ######################
	
	def match_uri_schema( request_uri_schema )
		
		return uri_schemas.empty? || uri_schemas.include?( request_uri_schema )
		
	end

end
