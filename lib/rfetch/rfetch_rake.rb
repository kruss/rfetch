# actions provided by rake-extention here

require "rfetch/rfetch"
require "rfetch/model/project_set"
require "rfetch/provider/svn_provider"
require "rfetch/provider/cvs_provider"
require "rfetch/task/info_task.rb"
require "rfetch/task/pull_task.rb"
require "rfetch/task/pull_noupdate_task.rb"
require "rfetch/task/pull_export_task.rb"
require "rfetch/task/clean_task.rb"

class RFetch2Rake
  include Rake::DSL if defined?(Rake::DSL)
  
  def initialize(set)
    @set = set
    @tasks = Array.new
    
    @set.pack()
    initTasks()
  end
  attr_accessor :set
  attr_accessor :tasks
  
private

  def initTasks()
    
    infoTask = InfoTask.new(@set).initTask()
    task :default => infoTask.name
    @tasks << infoTask
  
    @tasks << PullTask.new(@set).initTask()
    @tasks << PullExportTask.new(@set).initTask()
    @tasks << PullNoUpdateTask.new(@set).initTask()
    @tasks << CleanTask.new(@set).initTask()
  end

end
