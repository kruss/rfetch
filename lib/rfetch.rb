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

def getFlag(flag, default)
  if ENV[flag] != nil then
    if ENV[flag].eql?("true") then
      return true
    elsif ENV[flag].eql?("false") then
      return false
    else
      return default
    end
  else
    return default
  end
end

$APP_NAME = "rfetch"
$PROMPT = "$:"

$STRICT = getFlag("strict", true)
$VERBOSE = getFlag("verbose", false)