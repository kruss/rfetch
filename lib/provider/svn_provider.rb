require "provider/generic_provider"

class SvnProvider < GenericProvider
  PROVIDER_NAME = "SVN"
  HEAD_REVISION = "HEAD"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    
    if @revision.eql?(HEAD_REVISION) then
      @revision = getHeadRevision(@url)
      puts $PROMPT+" adjust: #{@url} (#{HEAD_REVISION}) -> (#{@revision})"
    end
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
        url = @url+"/"+project.name
        puts $PROMPT+" checkout: "+url+" ("+@revision+") -> "+project.localname
        checkoutProject(url, @revision, path, project.localname)
        
      elsif force then
        result.values["action"] = "update"
        puts $PROMPT+" update: "+project.localname+" ("+@revision+")"
        updateProject(@revision, path, project.localname) 
        
      else
        result.values["action"] = "skip"
        puts $PROMPT+" skip: "+project.localname
        
      end
      result.resolution = Feedback::Result.RESOLUTION[2] # SUCCEED
    end
    @result.resolution = Feedback::Result.RESOLUTION[2] # SUCCEED
  end
  
private

  def getHeadRevision(url)

    revision = nil
    out = IO.popen("svn info #{url}")
    out.readlines.each do |line|
      if line.index("Revision:") != nil then
        line.slice!("Revision:")
        revision = line.strip
      end
    end
    return revision
  end
  
  def checkoutProject(url, revision, path, localname)
    
    out = IO.popen("svn -r #{revision} checkout #{url} #{path}")
    out.readlines.each do |line|
      @output.log(localname, line)
    end
  end
  
  def updateProject(revision, path, localname)
    
    out = IO.popen("svn -r #{revision} update #{path}")
    out.readlines.each do |line|
      @output.log(localname, line)
    end
  end
  
end