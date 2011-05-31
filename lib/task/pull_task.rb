
require "rfetch"

class PullTask
    
  def initialize(set)
    @set = set
    @root = Pathname.new(Dir.getwd+"/"+@set.root).cleanpath.to_s
  end
  attr_accessor :set
  
  def getTask()
      
      desc "pull project-set or container at index"
      task "pull", [:index] do |t, args|
          
          if args.index == nil then
            pull()
          else
            pullIndex(args.index.to_i)
          end
      end
  end
  
private

  def pull()
    
    @set.containers.each do |container|
      pullContainer(container)
    end
  end
  
  def pullIndex(index)
    
    if index > 0 && index <= @set.containers.size then
      pullContainer(@set.containers[index-1])
    else
      raise "invalid index #{index}"
    end
  end
  
  def pullContainer(container)
    
    puts $PROMPT+" with #{container.info}"
    container.pull(@root)
  end

end