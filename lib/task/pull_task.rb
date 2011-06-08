require "task/generic_task.rb"

class PullTask < GenericTask
  
  def initialize(set)
    super("pull", "pull project-set", set)
  end
  
  def runTask()
    
    @set.containers.each do |container|
      container.provider.adjust()
    end
    
    @set.containers.each do |container|
      container.provider.pull(true)
    end
  end
  
end