require "rfetch"

class GenericCommand
  
  def initialize(name, description)
    @name = name
    @description = description
    @parse = nil
    @options = {}
  end
  attr_accessor :name
  attr_accessor :description
  
  def init()
  
    parser = OptionParser.new do |parse|
      @parse = parse
      @parse.banner = "+ #{@name} -> #{@description}"
      initOptions()
    end
    parser.parse!
   
  end
  
  def run()
    
    if validOptions()
      runCommand()
    else
      help()
    end
  end
  
  def help()
    puts @parse
  end
  
protected

  def initOptions  
  end
  
  def validOptions
    return true
  end
  
  def runCommand()
    raise NotImplementedError.new()
  end
  
end