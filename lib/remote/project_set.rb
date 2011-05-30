
$REVISION_HEAD = "HEAD"

class ProjectSet
  
  def initialize(name)
    @name = name
    @containers = Array.new
  end
  attr_accessor :name
  attr_accessor :containers
  
end

class Container
  
  def initialize(nature, uri)
    @nature = nature
    @uri = uri
    @projects = Array.new
  end
  attr_accessor :nature
  attr_accessor :uri
  attr_accessor :projects
  
end

class Project
  
  def initialize(name)
    @name = name
    @localname = nil
    @revision = $REVISION_HEAD
  end
  attr_accessor :name
  attr_accessor :localname
  attr_accessor :revision
  
end