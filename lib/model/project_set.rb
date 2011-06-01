
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
    end
  end
end

class Container
  PULL_MODE_FULL = "full"
  PULL_MODE_KEEP = "keep"
  
  def initialize(provider)
    @set = nil
    @provider = provider
    @projects = Array.new
  end
  attr_accessor :set
  attr_accessor :provider
  attr_accessor :projects
  
end

class Project
  
  def initialize(name)
    @name = name
    @localname = name
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