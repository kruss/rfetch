require "provider/generic_provider"

class CvsProvider < GenericProvider
  PROVIDER_NAME = "CVS"
  HEAD_REVISION = "HEAD"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    # adjust HEAD not supported
  end
  
  def pull(force)
    @result = Feedback::Result.new(@url)
    @result.values["provider"] = PROVIDER_NAME
    @result.values["revision"] = @revision
    @output.feedback.results << @result
    root = @container.set.getRoot()
    
    @container.projects.each do |project|
      result = Feedback::Result.new(project.localname)
      @result.results << result
      path = root+"/"+project.localname
      
      if !FileTest.directory?(path) then 
        result.values["action"] = "checkout"
        puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        checkoutProject(root, @url, @revision, project.name, project.localname)  
        
      elsif force then
        result.values["action"] = "update"
        puts $PROMPT+" update: "+project.localname+" ("+@revision+")"
        updateProject(root, @url, @revision, project.localname)  
        
      else
        result.values["action"] = "skip"
        puts $PROMPT+" skip: "+project.localname
        
      end
      result.resolution = Feedback::Result.RESOLUTION[2] # SUCCEED
    end
    @result.resolution = Feedback::Result.RESOLUTION[2] # SUCCEED
  end
  
private
  
  def checkoutProject(root, url, revision, name, localname)
    
    cd root do
      out = IO.popen("cvs -d #{url} checkout -r #{revision} -d #{localname} #{name}")
      out.readlines.each do |line|
        @output.log(localname, line)
      end
    end
  end
  
  def updateProject(root, url, revision, localname)
    
    cd root do
      out = IO.popen("cvs -d #{url} update -r #{revision} -d #{localname}")
      out.readlines.each do |line|
        @output.log(localname, line)
      end
    end
  end
  
end