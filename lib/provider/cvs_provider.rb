
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
    cd root do
      @container.projects.each do |project|
        
        if !FileTest.directory?(root+"/"+project.localname) then 
          puts $PROMPT+" checkout: "+@url+"/"+project.name+" ("+@revision+") -> "+project.localname
          checkoutProject(@url, @revision, project.name, project.localname)
          
        elsif update then
          puts $PROMPT+" update: "+project.localname+" ("+@revision+")"
          updateProject(@url, @revision, project.localname)
     
        else
          puts $PROMPT+" skip: "+path
        end
      end
    end
  end
  
private
  
  def checkoutProject(url, revision, name, localname)
    sh "cvs -d #{url} checkout -r #{revision} -d #{localname} #{name}"
  end
  
  def updateProject(url, revision, localname)
    sh "cvs -d #{url} update -r #{revision} -d #{localname}"
  end
  
end