
class ProjectSet
  
  def initialize(root)
    @root = root
    @containers = Array.new
  end
  attr_accessor :containers
  
  def getRoot()
    return Pathname.new(Dir.getwd+"/"+@root).cleanpath.to_s
  end
  
  def pack()
    containers.each do |container|
      container.set = self
      container.provider.container = container
    end
  end
end

class Container
  
  def initialize(provider)
    @provider = provider
    @projects = Array.new
    @set = nil
  end
  attr_accessor :provider
  attr_accessor :projects
  attr_accessor :set
  
  def info()
    return @provider.getName()+" -> #{@provider.url} (#{@provider.revision})"
  end
end

class Project
  
  def initialize(name, localname = name)
    @name = name
    @localname = localname
  end
  attr_accessor :name
  attr_accessor :localname

  def info()
    if @name.eql?(@localname) then
      return "#{@name}"  
    else
      return "#{@name} -> #{@localname}"  
    end
  end
end