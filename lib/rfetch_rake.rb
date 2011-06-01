# actions provided by rake-extention here

require "rfetch"
require "model/project_set"
require "provider/svn_provider"
require "task/generic_task.rb"

class RFetch2Rake
  
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
    @tasks << StatusTask.new(@set).initTask()
    @tasks << RevertTask.new(@set).initTask()
    @tasks << DropTask.new(@set).initTask()
  end

end

class InfoTask < GenericTask
  
  def initialize(set)
    super("info", nil, set)
  end
  
  def runTask()
    @set.containers.each do |container|
      puts "#{container.provider.info}" 
      container.projects.each do |project|
          puts " |- #{project.info}"
      end
    end
  end
end

class PullTask < GenericTask
  
  def initialize(set)
    super("pull", "pull project-set (mode=[full]|keep)", set)
  end
  
  def runTask()
    @set.containers.each do |container|
      mode = Container::PULL_MODE_FULL
      if ENV["mode"] != nil then
        mode = ENV["mode"]
      end
      container.provider.pull(container, @set.getRoot(), mode)
    end
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

class DropTask < GenericTask
  
  def initialize(set)
    super("drop", "drop project-set", set)
  end
end
