# actions provided by rake-extention here

require "rfetch"

class RFetch2Rake
  
  def initialize(sets)
    
    @sets = sets
    @tasks = Array.new
    
    initialize_tasks()
  end
  attr_accessor :sets
  attr_accessor :tasks
  
  def initialize_tasks()
    
    @tasks << InfoTask.new(@sets).getTask()
    @sets.each do |set|
      @tasks << PullTask.new(set).getTask()
      # TODO more tasks here
    end
  end

end