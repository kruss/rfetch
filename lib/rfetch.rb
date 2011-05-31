# all requires and constants here

require "rake"
require "pathname"
require "optparse"
require "util/logger"

require "model/project_set"
require "provider/providers"
require "provider/svn_provider"
require "rfetch_rake"

$APP_NAME = "rfetch"
$PROMPT = "$:"