
module ::Magnets::Request::Match::UserAgent

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_user_agent( request.user_agent )

	end

	######################
  #  match_user_agent  #
  ######################

	def match_user_agent( request_user_agent )
	
		return user_agents.empty? || user_agents.include?( request_user_agent )
	
	end	

end
