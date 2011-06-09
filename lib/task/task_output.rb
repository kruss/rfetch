
class TaskOutput
  
  def initialize(folder)
    @folder = folder
    @feedback = Feedback::Feedback.new()
    @init = false
  end
  attr_accessor :folder
  attr_accessor :feedback
  
  def open()
    
    if !@init then
      if FileTest.directory?(@folder) then
        FileUtils.rm_rf(@folder)
      end
      FileUtils.mkdir_p(@folder)
      @init = true
    else
      raise "invalid state"
    end
  end
  
  def close()
    
    if @init then
      @feedback.serialize(@folder+"/"+Feedback::Feedback.OUTPUT_FILE)
      @init = false
    else
      raise "invalid state"     
    end
  end
  
  def log(name, message)
    
    if @init then
      path = @folder+"/"+name+".log"
      file = File.new(path, "a")
      if file then
        file.syswrite(message)
        file.close
      else
         raise "error on file: "+path
      end
    else
      raise "invalid state" 
    end
  end
  
end