# task pulling a project-set

require "rfetch"

class PullTask
  
  def initialize(set)
    @set = set
  end
  attr_accessor :set
  
  def getTask()
    
      desc "pull project-set: #{set.name}"
      task "pull-#{set.name}" do
        runTask()
      end
  end
  
  def runTask()
    
    puts "pulling: #{set.name}..."
    #TODO
    
  end

end