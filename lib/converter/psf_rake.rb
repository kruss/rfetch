require "converter/svn_converter"
require "converter/cvs_converter"

class Psf2RakeConverter
  
  def initialize(psfFile, rakeFile, rootDir, revisionMap, urlMap)
    @psfFile = psfFile 
    @rakeFile = rakeFile
    @rootDir = rootDir
    @revisionMap = revisionMap
    @urlMap = urlMap
    @converter = nil
  end
  
  def convert()
    
    parsePsf(IO.readlines(@psfFile))
    if @revisionMap != nil then
      applyRevisionMap()
    end
    if @urlMap != nil then
      applyUrlMap() # this mapping last !
    end
    rake = createRake()
    write(@rakeFile, rake)

  end
  
private
  
  def parsePsf(lines)
    lines.each do |line|
      if line.index("<provider") != nil then
        parsePsfConverter(line)
      end
      if @converter != nil && line.index("<project") != nil then
        @converter.parsePsfProject(line)
      end
    end
  end
  
  # eg: <provider id="org.eclipse.team.svn.core.svnnature">
  def parsePsfConverter(line)
    if line.index("svnnature") != nil then
      @converter = SvnPsfConverter.new()
    elsif line.index("cvsnature") != nil then
      @converter = CvsPsfConverter.new()
    else
      raise "unsupported nature"
    end
  end
  
  def applyRevisionMap()
    
    @revisionMap.each do |map|
      maps = map.split("=")
      @converter.containers.each do |container|
        if container.url.eql?(maps[0]) then
          puts $PROMPT+" adjust: #{maps[0]} (#{container.revision}) -> (#{maps[1]})"
          container.revision = maps[1]
          break
        end
      end
    end
  end

  def applyUrlMap()
    
    @urlMap.each do |map|
      maps = map.split("=")
      @converter.containers.each do |container|
        if container.url.eql?(maps[0]) then
          puts $PROMPT+" adjust: #{maps[0]} -> #{maps[1]}"
          container.url = maps[1]
          break
        end
      end
    end
  end
  
  def createRake()
    
    rake = "require 'rfetch'\n"
    for i in 0..@converter.containers.size()-1 do
      container = @converter.containers[i]
      rake << "\ncontainer_#{i} = Container.new(\n"
      rake << "\t#{container.provider}.new(\"#{container.url}\", \"#{container.revision}\")\n"
      rake << ")\n"    
      
      for j in 0..container.projects.size()-1 do
        project = container.projects[j]
        rake << "container_#{i}.projects << "
        if project.name.eql?(project.localname) then
          rake << "Project.new(\"#{project.name}\")\n"
        else
          rake << "Project.new(\"#{project.name}\", \"#{project.localname}\")\n"
        end
        
      end
    end

    rake << "\nset = ProjectSet.new(\"#{@rootDir}\")\n"
    for i in 0..@converter.containers.size()-1 do
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