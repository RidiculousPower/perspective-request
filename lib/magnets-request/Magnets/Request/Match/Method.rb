
module ::Magnets::Request::Match::Method

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_method( request.request_method )

	end

	##################
  #  match_method  #
  ##################

	def match_method( request_method )

		return request_methods.empty? || request_methods.include?( request_method )
	
	end

end
