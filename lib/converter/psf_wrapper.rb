
class ContainerWrapper
    
  def initialize(provider, url, revision)
    @provider = provider
    @url = url
    @revision = revision
    @projects = Array.new
  end
  attr_accessor :url
  attr_accessor :revision
  attr_accessor :projects
    
  def createRake(object)
    rake = "#{object} = Container.new(\n"
    rake << "\t#{@provider}.new(\"#{@url}\", \"#{@revision}\")\n"
    rake << ")\n"
    return rake
  end
end
  
class ProjectWrapper
  
  def initialize(name, localname)
    @name = name
    @localname = localname
  end
  attr_accessor :name
  attr_accessor :localname
  
  def createRake(object)
    rake = "#{object} = Project.new(\"#{@name}\")\n"
    if !@name.eql?(@localname) then
      rake << "\t#{object}.localname = \"#{@localname}\"\n"
    end
    return rake
  end
end