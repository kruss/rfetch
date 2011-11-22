
class GenericProvider
  HEAD_REVISION     = "HEAD"
  PULL_FULL         = 1
  PULL_NOUPDATE     = 2
  PULL_EXPORT       = 3
  
  def initialize(url, revision = HEAD_REVISION)
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
  
  def pull(mode)
    if $FEEDBACK then
      container_result = Result.new(@url)
      container_result.properties["provider"] = getName()
      container_result.properties["revision"] = @revision
      container_result.status = Result.STATUS_ERROR
      @output.feedback.results << container_result
    end
    
    root = @container.set.getRoot()
    @container.projects.each do |project|
      if $FEEDBACK then
        project_result = Result.new(project.localname)
        project_result.status = Result.STATUS_ERROR
        container_result.results << project_result
      end
    
      path = root+"/"+project.localname
      if !FileTest.directory?(path) && (mode == PULL_FULL || mode == PULL_NOUPDATE) then 
        project_result.properties["action"] = "checkout"
        puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        checkoutProject(root, @url, project, @revision)   
      elsif FileTest.directory?(path) && mode == PULL_FULL then
        project_result.properties["action"] = "update"
        puts $PROMPT+" update: "+project.localname+" ("+@revision+")"
        updateProject(root, @url, project, @revision)          
      elsif !FileTest.directory?(path) && mode == PULL_EXPORT then 
        project_result.properties["action"] = "export"
        puts $PROMPT+" export "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        exportProject(root, @url, project, @revision)
      else
        project_result.properties["action"] = "skip"
        puts $PROMPT+" skip: "+project.localname          
      end

      if $FEEDBACK then
        project_result.status = Result.STATUS_SUCCEED
      end
    end
    if $FEEDBACK then
      container_result.status = Result.STATUS_SUCCEED
    end
  end

protected

  def checkoutProject(root, url, project, revision)
    raise NotImplementedError.new()
  end
  
  def exportProject(root, url, project, revision)
    raise NotImplementedError.new()
  end
  
  def updateProject(root, url, project, revision)
    raise NotImplementedError.new()
  end
  
end