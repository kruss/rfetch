
class GenericProvider
  
  def initialize(url, revision)
    @url = url
    @revision = revision 
    @container = nil
    @output = nil
  end
  attr_accessor :url
  attr_accessor :revision
  attr_accessor :container
  attr_accessor :output
  
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