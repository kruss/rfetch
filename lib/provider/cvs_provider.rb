
class CvsProvider < GenericProvider
  PROVIDER_NAME = "CVS"
  HEAD_REVISION = "HEAD"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    # adjust HEAD not supported
  end
  
  def pull(update)
    
    root = @container.set.getRoot()
    @container.projects.each do |project|
      path = root+"/"+project.localname
      if !FileTest.directory?(path) then 
        puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
        checkoutProject(root, @url, @revision, project.name, project.localname)       
      elsif update then
        puts $PROMPT+" update: "+path+" ("+@revision+")"
        updateProject(root, @url, @revision, project.localname)  
      else
        puts $PROMPT+" skip: "+path
      end
    end
  end
  
private
  
  def checkoutProject(root, url, revision, name, localname)
    cd root do
      sh "cvs -d #{url} checkout -r #{revision} -d #{localname} #{name}"
    end
  end
  
  def updateProject(root, url, revision, localname)
    cd root do
      sh "cvs -d #{url} update -r #{revision} -d #{localname}"
    end
  end
  
end