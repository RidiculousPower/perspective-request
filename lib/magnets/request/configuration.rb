
module ::Magnets::Request::Configuration

  ##############
  #  root      #
  #  root=     #
  #  set_root  #
  ##############
  
  attr_accessor :root
  alias_method  :set_root, :root=

  ########################
  #  root_instance       #
  #  set_root_instance=  #
  #  set_root_instance   #
  ########################
  
  attr_accessor :root_instance
  alias_method  :set_root_instance, :root_instance=

end
