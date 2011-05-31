
require "rfetch"

class GenericTask
    
  def initialize(name, description, set, indexed)
    @name = name
    @description = description
    @set = set
    @indexed = indexed
  end
  
  def initTask()

      desc @description
      if @indexed then
        task @name, [:index] do |t, args|
          if args.index == nil then
            runTask()
          else
            runTaskWithIndex(args.index.to_i)
          end
        end
      else
        task @name do |t|
          runTask()
        end
      end
  end
  
private

  def runTask()
    
    @set.containers.each do |container|
      runTaskFor(container)
    end
  end
  
  def runTaskWithIndex(index)
    
    if index > 0 && index <= @set.containers.size then
      runTaskFor(@set.containers[index])
    else
      raise "invalid index"
    end
  end
  
  def runTaskFor(container)
    
     puts $PROMPT+" #{@name} [#{container.getIndex().to_s}]"
     container.method(@name).call()
  end

end