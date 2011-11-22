require "rfetch/task/generic_task.rb"

class PullTask < GenericTask
  
  def initialize(set)
    super("pull", "pull project-set", set)
  end
  
  def runTask()
    begin
      @output.open()
      
      @set.containers.each do |container|
        container.provider.output = @output
        container.provider.adjust()
      end
      @set.containers.each do |container|
        container.provider.pull(GenericProvider::PULL_FULL)
      end
      
    ensure
      @output.close()
    end
  end
  
end