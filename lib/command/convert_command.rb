
require "command/generic_command"

class ConvertCommand < GenericCommand

  def initialize()
    super("psf2rake", "Convert a psf-File to rake-file")
  end
  
  def initOptions()
  
    @parse.on("-f", "--file FILE", "convert the psf-file FILE") do |file|
      @options[:PsfFile] = file
    end
    @parse.on("-o", "--output FILE", "generate the rake-file FILE") do |file|
      @options[:RakeFile] = file
    end
   
  end
  
  def validOptions()
    
    if @options[:PsfFile] != nil && @options[:RakeFile] != nil then
      return true
    end
    return false
    
  end
  
  def runCommand()

     puts $PROMPT+" #{@name}: #{@options[:PsfFile]} -> #{@options[:RakeFile]}"
     # ...
     
  end
end