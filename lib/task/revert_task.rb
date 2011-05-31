
require "rfetch"

class RevertTask

  def initialize(set)
    @set = set
  end
  attr_accessor :set
  
  def getTask()
    
      desc "revert the project-set"
      task "revert" do
          runTask()
      end
  end
  
private

  def runTask()
    
    root = Pathname.new(Dir.getwd+"/"+@set.root).cleanpath.to_s
    @set.containers.each do |container|
      container.revert(root)
    end
  end

end