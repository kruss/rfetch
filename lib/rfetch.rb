# all requires and constants here

require "rake"
require "pathname"
require "optparse"
require "util/logger"

require "remote/project_set"
require "task/info_task.rb"
require "task/pull_task.rb"
require "task/diff_task.rb"
require "task/revert_task.rb"
require "remote/providers"
require "remote/svn_provider"
require "rfetch_rake"

$APP_NAME = "rfetch"
$APP_VERSION = "0.1.0"
$PROMPT = "$:"