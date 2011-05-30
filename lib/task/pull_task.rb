# task pulling a project-set

require "rfetch"

class PullTask
  TASK_NAME = "pull"
    
  def initialize(set)
    @set = set
    @path = Dir.getwd
  end
  attr_accessor :set
  
  def getTask()
    
      desc "pull the project-set"
      task TASK_NAME do
          runTask()
      end
  end
  
private

  def runTask()
    
    @set.containers.each do |container|

      provider = Providers.getProvider(container.nature) 
      provider.pull(container, @path)
    end
  end

end