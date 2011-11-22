require "rfetch/task/generic_task.rb"

class PullNoUpdateTask < GenericTask
  
  def initialize(set)
    super("pull-noupdate", "pull project-set without update", set)
  end
  
  def runTask()
    begin
      @output.open()
      
      @set.containers.each do |container|
        container.provider.output = @output
        container.provider.adjust()
      end
      @set.containers.each do |container|
        container.provider.pull(GenericProvider::PULL_NOUPDATE)
      end
      
    ensure
      @output.close()
    end
  end
  
end