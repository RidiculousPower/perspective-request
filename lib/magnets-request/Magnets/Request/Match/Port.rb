
module ::Magnets::Request::Match::Port

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_port( request.port )

	end

	################
  #  match_port  #
  ################

	def match_port( request_port )
	
		return ports.empty? || ports.include?( request_port )
	
	end

end
