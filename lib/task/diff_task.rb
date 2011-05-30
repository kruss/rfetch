# task pulling a project-set

require "rfetch"

class DiffTask
  TASK_NAME = "diff"
    
  def initialize(set)
    @set = set
    @path = Dir.getwd
  end
  attr_accessor :set
  
  def getTask()
    
      desc "diff for the project-set"
      task TASK_NAME do
          runTask()
      end
  end
  
private

  def runTask()
    
    @set.containers.each do |container|

      provider = Providers.getProvider(container.nature) 
      provider.diff(container, @path)
    end
  end

end