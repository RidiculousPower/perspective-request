
module ::Magnets::Request::Match::IP

	###########
  #  match  #
  ###########

  def match( request )

		return super && match_ip( request.ip )

	end

	##############
  #  match_ip  #
  ##############
	
	def match_ip( request_ip )
	
		return ips.empty? || ips.include?( request_ip )
	
	end

end
