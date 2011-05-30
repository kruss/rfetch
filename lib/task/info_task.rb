# task providing info on a project-set

require "rfetch"

class InfoTask
  
  def initialize(sets)
    @sets = sets
  end
  attr_accessor :sets
  
  def getTask()
    
      desc "info on project-sets"
      task "info" do
        runTask()
      end
  end
  
  def runTask()
    
    @sets.each do |set|
      puts "+ #{set.name}"
      set.containers.each do |container|
        puts "|- #{container.uri} (#{container.nature})"
        container.projects.each do |project|
          if project.localname != nil then
            puts "|\t|- #{project.name} -> #{project.localname} (#{project.revision})"
          else
            puts "|\t|- #{project.name} (#{project.revision})"
          end
        end
      end
    end
  end
  
end