require "command/generic_command"
require "converter/psf_rake"


class ConvertCommand < GenericCommand

  def initialize()
    super("psf2rake", "Convert a psf-file to rake-file")
  end
  
  def initOptions()
  
    @parse.on("-f", "--file FILE", "convert the psf-file FILE") do |param|
      @options[:PsfFile] = param
    end
    @parse.on("-o", "--output FILE", "output to rake-file FILE (optional)") do |param|
      @options[:RakeFile] = param
    end
    @parse.on("-d", "--directory PATH", "path to root-directory (optional)") do |param|
      @options[:RootDir] = param
    end
    @parse.on("-r", "--revision LIST", "list of url=revision,... mapping (optional)") do |param|
      @options[:RevisionMap] = param
    end
    @parse.on("-u", "--url LIST", "list of url=url,... mapping (optional)") do |param|
      @options[:UrlMap] = param
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
    revisionMap = nil
    if @options[:RevisionMap] != nil then
      revisionMap = @options[:RevisionMap].split(",")
    end
    urlMap = nil
    if @options[:UrlMap] != nil then
      urlMap = @options[:UrlMap].split(",")
    end
    
    puts $PROMPT+" #{@name}: #{psfFile} -> #{rakeFile}"
    converter = Psf2RakeConverter.new(psfFile, rakeFile, rootDir, revisionMap, urlMap)
    converter.convert()
     
 end
 
end
