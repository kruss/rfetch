
class ProjectSet
  
  def initialize(root)
    @root = root
    @containers = Array.new
  end
  attr_accessor :root
  attr_accessor :containers
  
  def pack()
    index = 1
    containers.each do |container|
      container.index = index
      index = index + 1
    end
  end
end

class Container
  
  def initialize(provider)
    @index = nil
    @provider = provider
    @projects = Array.new
  end
  attr_accessor :index
  attr_accessor :provider
  attr_accessor :projects
  
  def info()
    return "[#{@index.to_s}] #{provider.info}"  
  end
  
  def pull(root)
    provider.pull(self, root)
  end
  
  def diff(root)
    provider.diff(self, root)
  end
  
  def revert(root)
    provider.revert(self, root)
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