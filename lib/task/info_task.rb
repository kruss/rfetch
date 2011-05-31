
require "rfetch"

class InfoTask
  
  def initialize(set)
    @set = set
  end
  attr_accessor :set
  
  def getTask()
    
      desc "info on project-set"
      task "info" do
        runTask()
      end
  end
  
private

  def runTask()
    
    @set.containers.each do |container|
      puts "+ #{container.provider.info}"
      container.projects.each do |project|
        if project.name.eql?(project.localname) then
          puts "|- #{project.name}"
        else
          puts "|- #{project.name} -> #{project.localname}"
        end
      end
    end
  end
  
end