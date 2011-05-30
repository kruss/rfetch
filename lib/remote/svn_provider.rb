
$SVN_NATURE = "SVN"

class SvnProvider
  
  def initialize(projecSet)
    if !projectSet.nature.eql?($SVN_NATURE) then
      raise "not my nature: "+projectSet.nature
    end
    
    @projecSet = projecSet
  end
  attr_accessor :projectSet
  
  def pull(directory)
    
    projectSet.containers.each do |container|
      containerUrl = container.uri
      puts $SVN_NATURE+" pull ["+containerUrl+"]"
      container.projects.each do |project|
        projectUrl = containerUrl+"/"+project.name
        revision = project.revision
        path = directory+"/"+project.getLocalName()
        pull(projectUrl, revision, path)
      end
    end
  end
  
  def pull(url, revision, path)
     puts $SVN_NATURE+" pull: "+url+" ("+revision+") -> "+path
     # TODO
  end
  
end