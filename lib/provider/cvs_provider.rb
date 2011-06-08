
class CvsProvider < GenericProvider
  PROVIDER_NAME = "CVS"
  HEAD_REVISION = "HEAD"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    
    if !@revision.eql?(HEAD_REVISION) then
      raise NotImplementedError.new()
    end
  end
  
  def pull(update)
    
    @container.projects.each do |project|
      path = @container.set.getRoot()+"/"+project.localname
      
      if !FileTest.directory?(path) then 
        puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        checkoutProject(@url, project.name, project.localname)
        
      elsif update then
        raise NotImplementedError.new()
   
      else
        puts $PROMPT+" already existing: "+path
      end
    end
  end
  
private
  
  def checkoutProject(url, component, localname)
    sh "cvs -d #{url} co -d #{localname} #{component}"
  end
  
end