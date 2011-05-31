
require "rfetch"

class DiffTask

  def initialize(set)
    @set = set
  end
  attr_accessor :set
  
  def getTask()
    
      desc "diff of project-set"
      task "diff" do
          runTask()
      end
  end
  
private

  def runTask()
    
    root = Pathname.new(Dir.getwd+"/"+@set.root).cleanpath.to_s
    @set.containers.each do |container|
      container.diff(root)
    end
  end

end