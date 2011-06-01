
require "rfetch"

class GenericTask
    
  def initialize(name, description, set)
    @name = name
    @description = description
    @set = set
  end
  
  def initTask()

      desc @description
      task @name do |t|
        runTask()
      end
  end
  
protected

  def runTask()
    @set.containers.each do |container|
      container.provider.method(@name).call(container, @set.getRoot())
    end
  end
end