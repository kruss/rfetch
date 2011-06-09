require "rfetch"
require "task/task_output.rb"

class GenericTask

  if $RAKE_DSL then 
    include Rake::DSL
  end
  
  def initialize(name, description, set)
    @name = name
    @description = description
    @set = set
    @output = TaskOutput.new(@set.getRoot()+"/.#{$APP_NAME}")

  end
  
  def initTask()

      desc @description
      task @name do |t|
        runTask()
      end
  end
  
protected

  def runTask()
    raise NotImplementedError.new()
  end
  
end