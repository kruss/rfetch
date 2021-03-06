require "rfetch/provider/generic_provider"

class ContainerWrapper
    
  def initialize(provider, url)
    @provider = provider
    @url = url
    @revision = GenericProvider::HEAD_REVISION
    @projects = Array.new
  end
  attr_accessor :provider
  attr_accessor :url
  attr_accessor :revision
  attr_accessor :projects
end
  
class ProjectWrapper
  
  def initialize(name, localname)
    @name = name
    @localname = localname
  end
  attr_accessor :name
  attr_accessor :localname
end