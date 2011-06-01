# actions provided by the gem here

require "rfetch"
require "command/convert_command"

class RFetchGem

	def initialize()
    @commands = Array.new
    @commands << ConvertCommand.new()
	end
	
	def run()
    command = getCommand(ARGV[0])  
    if command != nil then
      command.init()
      command.run()
    else
      help()
    end
	end
	
private
  
  def getCommand(name)
    @commands.each do |command|
      if command.name.eql?(name) then
        return command
      end
    end
    return nil
  end

  def help()
    puts "Usage: #{$APP_NAME} <command> [options ...]"
    @commands.each do |command|
      command.init()
      command.help()
    end
  end
end
