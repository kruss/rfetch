# task providing info on a project-set

require "rfetch"

class InfoTask
  TASK_NAME = "info"
  
  def initialize(set)
    @set = set
  end
  attr_accessor :sets
  
  def getTask()
    
      desc "info on project-set"
      task TASK_NAME do
        runTask()
      end
  end
  
private

  def runTask()
    
    @set.containers.each do |container|
      puts "+ #{container.uri} (#{container.nature})"
      container.projects.each do |project|
        if project.localname != nil then
          puts "|- #{project.name} -> #{project.localname} (#{project.revision})"
        else
          puts "|- #{project.name} (#{project.revision})"
        end
      end
    end
  end
  
end