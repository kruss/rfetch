
class SvnProvider
  NATURE = "SVN"
  
  def initialize()
    @nature = NATURE
  end
  attr_accessor :nature
  
  def pull(container, root)
    
      container.projects.each do |project|
        path = project.localname == nil ? root+"/"+project.name : root+"/"+project.localname
        revision = project.revision
        
        if !FileTest.directory?(path) then 
          url = container.uri+"/"+project.name
          puts "+ pull initial\n\t- url "+url+" ("+revision+")\n\t- path "+path
          checkoutProject(url, path, revision)
        else
          puts "+ pull update\n\t- path "+path+" ("+revision+")"
          updateProject(path, revision) 
        end
      end
  end
  
  def revert(container, root)
  
    container.projects.each do |project|
      path = project.localname == nil ? root+"/"+project.name : root+"/"+project.localname
      if FileTest.directory?(path) then 
        puts "+ revert\n\t- path "+path
        revertProject(path)
      end
    end
  end
  
  def diff(container, root)
  
    container.projects.each do |project|
      path = project.localname == nil ? root+"/"+project.name : root+"/"+project.localname
      if FileTest.directory?(path) then 
        puts "+ diff\n\t- path "+path
        diffProject(path)
      end
    end
  end
  
private

  def checkoutProject(url, path, revision)
    sh "svn -r #{revision} checkout #{url} #{path}"
  end
  
  def updateProject(path, revision)
    sh "svn -r #{revision} update #{path}"
  end
  
  def revertProject(path)
    sh "svn -R revert #{path}"
  end
  
  def diffProject(path)
    sh "svn diff #{path}"
  end
  
end