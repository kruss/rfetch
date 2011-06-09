
class GenericProvider
  
  def initialize(url, revision)
    @url = url
    @revision = revision 
    @container = nil
    @output = nil
  end
  attr_accessor :url
  attr_accessor :revision
  attr_accessor :container
  attr_accessor :output
  
  def getName()
    raise NotImplementedError.new()
  end
  
  def adjust()
    raise NotImplementedError.new()
  end
  
  def pull(force)
    
    @result = Feedback::Result.new(@url)
    @result.values["provider"] = getName()
    @result.values["revision"] = @revision
    @output.feedback.results << @result
    
    root = @container.set.getRoot()
    @container.projects.each do |project|
      result = Feedback::Result.new(project.localname)
      @result.results << result
      
      if !FileTest.directory?(root+"/"+project.localname) then 
        result.values["action"] = "checkout"
        puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        checkoutProject(root, @url, project, @revision)
        
      elsif force then
        result.values["action"] = "update"
        puts $PROMPT+" update: "+project.localname+" ("+@revision+")"
        updateProject(root, @url, project, @revision) 
        
      else
        result.values["action"] = "skip"
        puts $PROMPT+" skip: "+project.localname
        
      end
      result.resolution = Feedback::Result.RESOLUTION[2] # SUCCEED
    end
    @result.resolution = Feedback::Result.RESOLUTION[2] # SUCCEED
  end

protected

  def checkoutProject(root, url, project, revision)
    raise NotImplementedError.new()
  end
  
  def updateProject(root, url, project, revision)
    raise NotImplementedError.new()
  end
  
end