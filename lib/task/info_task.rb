require "task/generic_task.rb"

class InfoTask < GenericTask
  
  def initialize(set)
    super("info", nil, set)
  end
  
  def runTask()
    
    @set.containers.each do |container|
      puts "#{container.info}" 
      container.projects.each do |project|
          puts " |- #{project.info}"
      end
    end
  end
  
end