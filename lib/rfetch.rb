# external requires and constants here

require "rake"
begin
  require "rake/dsl_definition"
rescue LoadError => e
  #nothing
end

require "pathname"
require "optparse"
require "feedback"

require "rfetch_rake"
require "rfetch_gem"

$APP_NAME = "rfetch"
$PROMPT = "$:"