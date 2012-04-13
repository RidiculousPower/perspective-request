
module ::Magnets::Request::Match::Host

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_host( request.host )

	end
	
	################
  #  match_host  #
  ################

	def match_host( request_host )
	
		return hosts.empty? || hosts.include?( request_host )
	
	end

end
