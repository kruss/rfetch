# all requires and constants here

require "rake"
require "optparse"
require "util/logger"

require "remote/project_set"
require "task/info_task.rb"
require "task/pull_task.rb"
require "remote/providers"
require "remote/svn_provider"
require "rfetch_rake"

$AppName = "rfetch"
$AppVersion = "0.1.0"