# actions provided by rake-extention here

require "rfetch"
require "model/project_set"
require "provider/svn_provider"
require "provider/cvs_provider"
require "task/info_task.rb"
require "task/pull_task.rb"
require "task/pull_noupdate_task.rb"
require "task/clean_task.rb"

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
    @tasks << PullNoUpdateTask.new(@set).initTask()
    @tasks << CleanTask.new(@set).initTask()
  end

end
