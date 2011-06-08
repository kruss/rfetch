require "task/generic_task.rb"

class PullNoUpdateTask < GenericTask
  
  def initialize(set)
    super("pull-noupdate", "pull project-set without update", set)
  end
  
  def runTask()
    
    @set.containers.each do |container|
      container.provider.adjust()
    end
    
    @set.containers.each do |container|
      container.provider.pull(false)
    end
  end
  
end