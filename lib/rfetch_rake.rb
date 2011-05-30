# actions provided by rake-extention here

require "rfetch"

class RFetch2Rake
  
  def initialize(set)
    
    @set = set
    @tasks = Array.new
    
    initialize_tasks()
  end
  attr_accessor :set
  attr_accessor :tasks
  
private

  def initialize_tasks()
    
    @tasks << InfoTask.new(@set).getTask()
    @tasks << PullTask.new(@set).getTask()
    @tasks << DiffTask.new(@set).getTask()
    @tasks << RevertTask.new(@set).getTask()
    # TODO more tasks here
    
    setDefaultTask()
  end
  
  def setDefaultTask()
    task :default => [InfoTask::TASK_NAME]
  end

end