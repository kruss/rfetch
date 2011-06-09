require "task/generic_task.rb"

class CleanTask < GenericTask
  
  def initialize(set)
    super("clean", "remove project-set files", set)
  end
  
  def runTask()
    
    @set.containers.each do |container|
      container.projects.each do |project|
        
        path = @set.getRoot()+"/"+project.localname
        if FileTest.directory?(path) then 
          puts $PROMPT+" delete: "+path
          FileUtils.rm_rf(path)
        end
      end
    end
    
    if FileTest.directory?(@output.folder) then
      FileUtils.rm_rf(@output.folder)
    end
  end
  
end