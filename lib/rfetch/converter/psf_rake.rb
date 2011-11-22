require "rfetch/converter/svn_converter"
require "rfetch/converter/cvs_converter"
require "rfetch/provider/generic_provider"

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
      applyUrlMap() # this mapping at last !
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
      url = maps[0]
      revision = maps[1]
      @converter.containers.each do |container|
        if container.url.eql?(url) then
          puts $PROMPT+" adjust: #{container.url} (#{container.revision}) -> (#{revision})"
          container.revision = revision
          break
        end
      end
    end
  end

  def applyUrlMap()
    
    @urlMap.each do |map|
      maps = map.split("=")
      url_org = maps[0]
      url_new = maps[1]
      @converter.containers.each do |container|
        if container.url.eql?(url_org) then
          puts $PROMPT+" adjust: #{container.url} -> #{url_new}"
          container.url = url_new
          break
        end
      end
    end
  end
  
  def createRake()
    
    rake = "require 'rfetch'\n"
    for i in 0..@converter.containers.size()-1 do
      
      container = @converter.containers[i]
      rake << "\ncontainer#{(i+1)} = Container.new(\n"
      if container.revision.eql?(GenericProvider::HEAD_REVISION) then
        rake << "\t#{container.provider}.new(\"#{container.url}\")\n"
      else
        rake << "\t#{container.provider}.new(\"#{container.url}\", \"#{container.revision}\")\n"
      end
      rake << ")\n"    
      
      if container.projects.size() > 0 then
        rake << "container#{(i+1)}.projects \\\n"
        for j in 0..container.projects.size()-1 do
          project = container.projects[j]
          if project.name.eql?(project.localname) then
            rake << "\t<< Project.new(\"#{project.name}\")"
          else
            rake << "\t<< Project.new(\"#{project.name}\", \"#{project.localname}\")"
          end       
          if j < container.projects.size()-1 then
            rake << " \\\n"
          else
            rake << "\n"
          end
        end
      end
    end

    rake << "\nset = ProjectSet.new(\"#{@rootDir}\")\n"
    if @converter.containers.size() > 0 then
      rake << "set.containers \\\n"
      for i in 0..@converter.containers.size()-1 do
        rake << "\t<< container#{(i+1)}"
        if i < @converter.containers.size()-1 then
          rake << " \\\n"
        else
          rake << "\n"
        end
      end
    end
    rake << "\nRFetch2Rake.new(set)\n" 
    
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