# actions provided by the gem here

require "rfetch"

class RFetchGem

	def initialize()
    @commands = Array.new
	end
	
	# run unit-tests
	def run()
    command = getCommand(ARGV[0])  
    command.run()
	end
	
private
  
  def getCommand(name)
    
    case name
      when ConvertCommand::COMMAND_NAME
        return ConvertCommand.new()
      else
        return HelpCommand.new()
    end
  end

end

class HelpCommand
  def run()
    puts "Help..."
  end
end

class ConvertCommand
  COMMAND_NAME = "convert"
  def run()
    puts "Convert..."
  end
end