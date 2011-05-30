# task pulling a project-set

require "rfetch"

class RevertTask
  TASK_NAME = "revert"
    
  def initialize(set)
    @set = set
    @path = Dir.getwd
  end
  attr_accessor :set
  
  def getTask()
    
      desc "revert the project-set"
      task TASK_NAME do
          runTask()
      end
  end
  
private

  def runTask()
    
    @set.containers.each do |container|

      provider = Providers.getProvider(container.nature) 
      provider.revert(container, @path)
    end
  end

end