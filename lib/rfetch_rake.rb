# actions provided by rake-extention here

require "rfetch"
require "task/generic_task.rb"

class RFetch2Rake
  
  def initialize(set)
    @set = set
    @tasks = Array.new
    
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
    @tasks << StatusTask.new(@set).initTask()
    @tasks << RevertTask.new(@set).initTask()
  end

end

class InfoTask < GenericTask
  
  def initialize(set)
    super("info", "print info on project-set", set)
  end
end

class PullTask < GenericTask
  
  def initialize(set)
    super("pull", "pull project-set", set)
  end
end

class StatusTask < GenericTask
  
  def initialize(set)
    super("status", "print status of project-set", set)
  end
end

class RevertTask < GenericTask
  
  def initialize(set)
    super("revert", "revert project-set", set)
  end
end