
require "command/generic_command"

class ConvertCommand < GenericCommand

  def initialize()
    super("psf2rake", "Convert a psf-File to rake-file")
  end
  
  def initOptions()
  
    @parse.on("-f", "--file FILE", "convert the psf-file FILE") do |file|
      @options[:PsfFile] = file
    end
    @parse.on("-o", "--output FILE", "output to rake-file FILE (optional)") do |file|
      @options[:RakeFile] = file
    end
    @parse.on("-r", "--root PATH", "path of the rake-root (optional)") do |root|
      @options[:RakeRoot] = root
    end
   
  end
  
  def validOptions()
    
    if @options[:PsfFile] != nil then
      return true
    end
    return false
    
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
    
    puts $PROMPT+" #{@name}: #{psfFile} -> #{rakeFile}"
    converter = Psf2RakeConverter.new(psfFile, rakeFile, rakeRoot)
    converter.convert()
     
  end
end

class Psf2RakeConverter
  
  def initialize(psfFile, rakeFile, rakeRoot)
    @psfFile = psfFile 
    @rakeFile = rakeFile
    @rakeRoot = rakeRoot
    @driver = nil
  end
  
  def convert()
    
    parsePsf(IO.readlines(@psfFile))
    rake = createRake()
    write(@rakeFile, rake)

  end
  
private
  
  def parsePsf(lines)
    lines.each do |line|
      if line.index("<provider") != nil then
        parsePsfDriver(line)
      end
      if @driver != nil && line.index("<project") != nil then
        @driver.parsePsfProject(line)
      end
    end
  end
  
  # eg: <provider id="org.eclipse.team.svn.core.svnnature">
  def parsePsfDriver(line)
    if line.index("svnnature") != nil then
      @driver = SvnPsfDriver.new()
    else
      raise "unsupported nature"
    end
  end

  def createRake()
    
    rake = "require 'rfetch'\n"
    for i in 0..@driver.containers.size()-1 do
      container = @driver.containers[i]
      rake << "\n"+container.createRake("container_#{i}")
      for j in 0..container.projects.size()-1 do
        project = container.projects[j]
        rake << project.createRake("project_#{i}_#{j}")
        rake << "container_#{i}.projects << project_#{i}_#{j}\n"
      end
    end
    #...
    rake << "\nset = ProjectSet.new(\"#{@rakeRoot}\")\n"
    for i in 0..@driver.containers.size()-1 do
      rake << "\tset.containers << container_#{i}\n"
    end
    rake << "RFetch2Rake.new(set)\n" 
    return rake
  end
  
  def write(path, content)
  
    file = File.new(path, "w")
    if file
      file.syswrite(content)
      file.close
    else
       raise "could not write: "+path
    end
  end
  
end

class SvnPsfDriver
  
  def initialize()
    @containers = Array.new
  end
  attr_accessor :containers
  
  # eg: <project reference="1.0.1,svn://10.40.38.84:3690/cppdemo/trunk/Dummy,Dummy,707311c94308001012d0ecc66e85647a;svn://10.40.38.84:3690/cppdemo;svn://10.40.38.84:3690/cppdemo;branches;tags;trunk;true;0fcde1b6-b28e-6845-9283-8db7a2e7b6eb;svn://10.40.38.84:3690/cppdemo;;false;;;22"/>
  def parsePsfProject(line)
    splitLine = line.split(",")
    projectUrl = splitLine[1]
    localname = splitLine[2]
    splitUrl = projectUrl.split("/")
    name = splitUrl[splitUrl.size()-1]
    url = projectUrl.chomp("/"+name)
    
    puts $PROMPT+" converting: #{url}/#{name}|#{localname}"
    container = getContainer(url)
    container.projects << ProjectWrapper.new(name, localname)
  end
  
  def getContainer(url)
    
    @containers.each do |container|
      if container.url.eql?(url) then
        return container
      end
    end
    container = ContainerWrapper.new(url)
    @containers << container
    return container
  end
  
  class ContainerWrapper
    
    def initialize(url)
      @url = url
      @projects = Array.new
    end
    attr_accessor :url
    attr_accessor :projects
    
    def createRake(object)
      rake = "#{object} = Container.new(\n"
      rake << "\tSvnProvider.new(\"#{@url}\", SvnProvider::HEAD_REVISION)\n"
      rake << ")\n"
      return rake
    end
  end
end

class ProjectWrapper
  
  def initialize(name, localname)
    @name = name
    @localname = localname
  end
  attr_accessor :name
  attr_accessor :localname
  
  def createRake(object)
    rake = "#{object} = Project.new(\"#{@name}\")\n"
    if !@name.eql?(@localname) then
      rake << "\t#{object}.localname = \"#{@localname}\"\n"
    end
    return rake
  end
end