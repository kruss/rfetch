
class SvnProvider
  HEAD_REVISION = "HEAD"
  
  def initialize(url, revision)
    @url = url
    @revision = revision 
  end
  attr_accessor :url
  attr_accessor :revision
  
  def info()
    return "SVN -> #{@url} (#{revision})"
  end
  
  def pull(container, root)
    
      container.projects.each do |project|
        path = root+"/"+project.localname
        
        if !FileTest.directory?(path) then 
          url = @url+"/"+project.name
          puts $PROMPT+" checkout -> "+url+" ("+@revision+") -> "+path
          checkoutProject(url, @revision, path)
        else
          puts $PROMPT+" update -> "+path+" ("+@revision+")"
          updateProject(@revision, path) 
        end
      end
  end
  
  def diff(container, root)
  
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if FileTest.directory?(path) then 
        puts $PROMPT+" diff -> "+path
        diffProject(path)
      end
    end
  end
  
  def revert(container, root)
  
    container.projects.each do |project|
      path = root+"/"+project.localname
      
      if FileTest.directory?(path) then 
        puts $PROMPT+" revert -> "+path
        revertProject(path)
      end
    end
  end
  
private

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
  
end