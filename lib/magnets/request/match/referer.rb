
module ::Magnets::Request::Match::Referer

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_referer( request.referer )

	end

	###################
  #  match_referer  #
  ###################

	def match_referer( request_referer )
	
		return referers.empty? || referers.include?( request_referer )
	
	end

end
