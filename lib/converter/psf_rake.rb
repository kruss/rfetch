require "converter/svn_converter"
require "converter/cvs_converter"

class Psf2RakeConverter
  
  def initialize(psfFile, rakeFile, rakeRoot, urlAdjusts)
    @psfFile = psfFile 
    @rakeFile = rakeFile
    @rakeRoot = rakeRoot
    @urlAdjusts = urlAdjusts
    @converter = nil
  end
  
  def convert()
    
    parsePsf(IO.readlines(@psfFile))
    if @urlAdjusts != nil then
      adjustUrls()
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

  def adjustUrls()
    
    @urlAdjusts.each do |urlAdjust|
      urls = urlAdjust.split("=")
      @converter.containers.each do |container|
        if container.url.eql?(urls[0]) then
          puts $PROMPT+" adjust: #{urls[0]} -> #{urls[1]}"
          container.url = urls[1]
          break
        end
      end
    end
  end
  
  def createRake()
    
    rake = "require 'rfetch'\n"
    for i in 0..@converter.containers.size()-1 do
      container = @converter.containers[i]
      rake << "\n"+container.createRake("container_#{i}")
      for j in 0..container.projects.size()-1 do
        project = container.projects[j]
        rake << project.createRake("project_#{i}_#{j}")
        rake << "container_#{i}.projects << project_#{i}_#{j}\n"
      end
    end
    #...
    rake << "\nset = ProjectSet.new(\"#{@rakeRoot}\")\n"
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