require "rfetch/task/generic_task.rb"

class PullExportTask < GenericTask
  
  def initialize(set)
    super("pull-export", "pull project-set without meta", set)
  end
  
  def runTask()
    begin
      @output.open()
      
      @set.containers.each do |container|
        container.provider.output = @output
        container.provider.adjust()
      end
      @set.containers.each do |container|
        container.provider.pull(GenericProvider::PULL_EXPORT)
      end
      
    ensure
      @output.close()
    end
  end
  
end