require "provider/generic_provider"

class GenericProvider
  
  def initialize(url, revision)
    @container = nil
    @url = url
    @revision = revision 
  end
  attr_accessor :container
  attr_accessor :url
  attr_accessor :revision
  
  def getName()
    raise NotImplementedError.new()
  end
  
  def adjust()
    raise NotImplementedError.new()
  end
  
  def pull(force)
    raise NotImplementedError.new()
  end
  
end