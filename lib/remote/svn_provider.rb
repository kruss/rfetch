
class SvnProvider
  NATURE = "SVN"
  
  def initialize()
    @nature = NATURE
  end
  attr_accessor :nature
  
  def pull(container, path)
    
      container.projects.each do |project|
        url = container.uri+"/"+project.name
        revision = project.revision
        path = project.localname == nil ? path+"/"+project.name : path+"/"+project.localname
        
        pullProject(url, revision, path)
      end
  end
  
private

  def pullProject(url, revision, path)
    
    if !FileTest.directory?(path) then 
      puts "pull initial\n- from: "+url+" ("+revision+")\n- to: "+path
      
    else
      puts "pull update\n- from: "+url+" ("+revision+")\n- to: "+path
      
    end
  end
  
end