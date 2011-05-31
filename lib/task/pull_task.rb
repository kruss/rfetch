
require "rfetch"

class PullTask
    
  def initialize(set)
    @set = set
  end
  attr_accessor :set
  
  def getTask()
    
      desc "pull the project-set"
      task "pull" do
          runTask()
      end
  end
  
private

  def runTask()
    
    root = Pathname.new(Dir.getwd+"/"+@set.root).cleanpath.to_s
    @set.containers.each do |container|
      container.pull(root)
    end
  end

end