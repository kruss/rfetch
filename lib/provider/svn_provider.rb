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
      puts $PROMPT+" adjust: #{url} (#{HEAD_REVISION}) -> (#{@revision})"
    end
  end
  
  def pull(update)
    
    @container.projects.each do |project|
      path = @container.set.getRoot()+"/"+project.localname
      
      if !FileTest.directory?(path) then 
        url = @url+"/"+project.name
        puts $PROMPT+" checkout: "+url+" ("+@revision+") -> "+path
        checkoutProject(url, @revision, path)
        
      elsif update then
        puts $PROMPT+" update: "+path+" ("+@revision+")"
        updateProject(@revision, path) 
      
      else
        puts $PROMPT+" skip: "+path
      end
    end
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
  
  def checkoutProject(url, revision, path)
    sh "svn -r #{revision} checkout #{url} #{path}"
  end
  
  def updateProject(revision, path)
    sh "svn -r #{revision} update #{path}"
  end
  
end