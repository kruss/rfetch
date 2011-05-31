
class ProjectSet
  
  def initialize(root)
    @root = root
    @containers = Array.new
  end
  attr_accessor :containers
  
  def getRoot()
    return Pathname.new(Dir.getwd+"/"+@root).cleanpath.to_s
  end
  
  def getIndex(container)
    index = 0
    containers.each do |entry|
      if entry.equal?(container) then
        return index
      end
      index = index + 1
    end
    return -1
  end
  
  def pack()
    containers.each do |container|
      container.set = self
    end
  end
end

class Container
  
  def initialize(provider)
    @set = nil
    @provider = provider
    @projects = Array.new
  end
  attr_accessor :set
  attr_accessor :provider
  attr_accessor :projects
  
  def getIndex()
    return set.getIndex(self)
  end
  
  def info()
    puts "#{provider.info}" 
    projects.each do |project|
        puts " |- #{project.info}"
    end
  end
  
  def pull()
    provider.pull(self, @set.getRoot())
  end
  
  def status()
    provider.status(self, @set.getRoot())
  end
  
  def revert()
    provider.revert(self, @set.getRoot())
  end
  
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