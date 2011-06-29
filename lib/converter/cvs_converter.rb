require "converter/psf_wrapper"

class CvsPsfConverter
  
  def initialize()
    @containers = Array.new
  end
  attr_accessor :containers
  
  # eg: <project reference="1.0,:extssh:cvs.teststatt.de:443/data/var/lib/cvs,zgw/aliveMessageSender,aliveMessageSender"/>
  def parsePsfProject(line)
    
    splitLine = line.split(",")
    url = splitLine[1]
    name = splitLine[2]
    localname = splitLine[3].split("\"")[0]
    
    puts $PROMPT+" convert: #{url}/#{name}|#{localname}"
    container = getContainer(url)
    container.projects << ProjectWrapper.new(name, localname)
  end
  
  def getContainer(url)
    
    @containers.each do |container|
      if container.url.eql?(url) then
        return container
      end
    end
    container = ContainerWrapper.new("CvsProvider", url)
    @containers << container
    return container
  end
end

