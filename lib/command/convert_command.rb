
require "command/generic_command"
require "converter/psf_rake"


class ConvertCommand < GenericCommand

  def initialize()
    super("psf2rake", "Convert a psf-File to rake-file")
  end
  
  def initOptions()
  
    @parse.on("-f", "--file FILE", "convert the psf-file FILE") do |param|
      @options[:PsfFile] = param
    end
    @parse.on("-o", "--output FILE", "output to rake-file FILE (optional)") do |param|
      @options[:RakeFile] = param
    end
    @parse.on("-r", "--root PATH", "path of the rake-root (optional)") do |param|
      @options[:RakeRoot] = param
    end
    @parse.on("-u", "--url LIST", "list of url=url,... adjustments (optional)") do |param|
      @options[:UrlAdjusts] = param
    end
   
  end
  
  def validOptions()
    
    if @options[:PsfFile] != nil then
      return true
    else
      return false
    end
  end
  
  def runCommand()

    psfFile = @options[:PsfFile]
    rakeFile = @options[:RakeFile]
    if rakeFile == nil then
      rakeFile = psfFile.chomp(".psf")+".rb"
    end
    rakeRoot = @options[:RakeRoot]
    if rakeRoot == nil then
      rakeRoot = "."
    end
    urlAdjusts = nil
    if @options[:UrlAdjusts] != nil
      urlAdjusts = @options[:UrlAdjusts].split(",")
    end
    
    puts $PROMPT+" #{@name}: #{psfFile} -> #{rakeFile}"
    converter = Psf2RakeConverter.new(psfFile, rakeFile, rakeRoot, urlAdjusts)
    converter.convert()
     
  end
end
