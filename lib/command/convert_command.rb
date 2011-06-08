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
    @parse.on("-d", "--directory PATH", "path to the root-directory (optional)") do |param|
      @options[:RootDir] = param
    end
    @parse.on("-u", "--url LIST", "list of url=url,... mappings (optional)") do |param|
      @options[:UrlMapping] = param
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
    rootDir = @options[:RootDir]
    if rootDir == nil then
      rootDir = "."
    end
    urlMappings = nil
    if @options[:UrlMapping] != nil
      urlMappings = @options[:UrlMapping].split(",")
    end
    
    puts $PROMPT+" #{@name}: #{psfFile} -> #{rakeFile}"
    converter = Psf2RakeConverter.new(psfFile, rakeFile, rootDir, urlMappings)
    converter.convert()
     
 end
 
end
