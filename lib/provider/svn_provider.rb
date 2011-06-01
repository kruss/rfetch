
class SvnProvider
  PROVIDER_NAME = "SVN"
  HEAD_REVISION = "HEAD"
  
  def initialize(url, revision)
    @url = url
    @revision = revision 
  end
  attr_accessor :url
  attr_accessor :revision
  
  def info()
    return PROVIDER_NAME+" -> #{@url} (#{revision})"
  end
  
  def adjust()
    if @revision.eql?(HEAD_REVISION) then
      @revision = getHeadRevision(@url)
    end
  end
  
  def pull(container, root, mode)
    
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if !FileTest.directory?(path) then 
        url = @url+"/"+project.name
        puts $PROMPT+" checkout -> "+url+" ("+@revision+") -> "+path
        checkoutProject(url, @revision, path)
        
      elsif !mode.eql?(Container::PULL_MODE_KEEP) then
        puts $PROMPT+" update -> "+path+" ("+@revision+")"
        updateProject(@revision, path) 
      
      else
        puts $PROMPT+" already existing -> "+path
      end
    end
  end
  
  def status(container, root)
  
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if FileTest.directory?(path) then 
        puts $PROMPT+" diff -> "+path
        diffProject(path)
      else
        puts $PROMPT+" not existing -> "+path
      end
    end
  end
  
  def revert(container, root)
  
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if FileTest.directory?(path) then 
        puts $PROMPT+" revert -> "+path
        revertProject(path)
      else
        puts $PROMPT+" not existing -> "+path
      end
    end
  end
  
  def drop(container, root)
  
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if FileTest.directory?(path) then 
        puts $PROMPT+" delete -> "+path
        deleteProject(path)
      else
        puts $PROMPT+" not existing -> "+path
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
        puts $PROMPT+" #{url} (#{HEAD_REVISION}) -> (#{revision})"
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
  
  def diffProject(path)
    sh "svn diff #{path}"
  end
  
  def revertProject(path)
    sh "svn -R revert #{path}"
  end
  
  def deleteProject(path)
    FileUtils.rm_rf(path)
  end
  
end