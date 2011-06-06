require "converter/psf_wrapper"

class SvnPsfConverter
  
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
    container = ContainerWrapper.new("SvnProvider", url)
    @containers << container
    return container
  end
end

