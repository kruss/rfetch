
class ProjectSet
  
  def initialize(root)
    @root = root
    @containers = Array.new
  end
  attr_accessor :root
  attr_accessor :containers
  
end

class Container
  
  def initialize(provider)
    @provider = provider
    @projects = Array.new
  end
  attr_accessor :provider
  attr_accessor :projects
  
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

end