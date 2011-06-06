
class CvsProvider
  PROVIDER_NAME = "CVS"
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
    
    if !@revision.eql?(HEAD_REVISION) then
      raise "revision not supported"
    end
  end
  
  def pull(container, root, mode)
    
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if !FileTest.directory?(path) then 

        puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        checkoutProject(@url, project.name, project.localname)
        
      elsif !mode.eql?(Container::PULL_MODE_KEEP) then
        raise "update not supported"
   
      else
        puts $PROMPT+" already existing: "+path
      end
    end
  end
  
  def status(container, root)
    raise "status not supported"
  end
  
  def revert(container, root)
    raise "revert not supported"
  end
  
  def drop(container, root)
  
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if FileTest.directory?(path) then 
        puts $PROMPT+" delete: "+path
        deleteProject(path)
      else
        puts $PROMPT+" not existing: "+path
      end
    end
  end
  
private
  
  def checkoutProject(url, component, localname)
    sh "cvs -d #{url} co -d #{localname} #{component}"
  end
  
  def deleteProject(path)
    FileUtils.rm_rf(path)
  end
  
end