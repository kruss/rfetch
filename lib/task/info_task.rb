
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
      puts "#{container.info}"
      container.projects.each do |project|
        puts " |- #{project.info}"
      end
    end
  end
  
end