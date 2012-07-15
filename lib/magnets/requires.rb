
require 'rack'

basepath = 'request'

files = [
  
  'configuration',
  'rack_application',
  'path',
  'interface',
  
  'match/host',
  'match/ip',
  'match/method',
  'match/port',
  'match/referer',
  'match/uri_Schema',
  'match/user_agent'

]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
