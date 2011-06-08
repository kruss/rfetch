# external requires and constants here

require "rake"
begin
  $RAKE_DSL = true
  require "rake/dsl_definition"
rescue LoadError => e
  $RAKE_DSL = false
end

require "pathname"
require "optparse"

require "rfetch_rake"
require "rfetch_gem"

$APP_NAME = "rfetch"
$PROMPT = "$:"