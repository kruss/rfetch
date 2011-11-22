require "rfetch/provider/generic_provider"
require "rfetch/util/command"

class SvnProvider < GenericProvider
  PROVIDER_NAME = "SVN"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    
    if @revision.eql?(HEAD_REVISION) then
      revision = getHeadRevision(@url)
      if revision != nil then
        puts $PROMPT+" adjust: #{@url} (#{@revision}) -> (#{revision})"
        @revision = revision
      else
        message = "Could not adjust #{HEAD_REVISION} revision: #{@url}"
        if $STRICT then
          raise message
        else
          puts $PROMPT+" !!! Error !!! #{message}"
        end
      end
    end
  end
  
protected

  def checkoutProject(root, url, project, revision)
    url = url+"/"+project.name
    path = root+"/"+project.localname
    
    out = Command.call("svn -r #{revision} checkout #{url}@#{revision} #{path}")
    out.each_line do |line|
      @output.log(project.localname, line)
    end
  end

  def exportProject(root, url, project, revision)
    url = url+"/"+project.name
    path = root+"/"+project.localname
    
    out = Command.call("svn -r #{revision} export #{url}@#{revision} #{path}")
    out.each_line do |line|
      @output.log(project.localname, line)
    end
  end
  
  def updateProject(root, url, project, revision)
    path = root+"/"+project.localname
    
    out = Command.call("svn -r #{revision} update #{path}")
    out.each_line do |line|
      @output.log(project.localname, line)
    end
  end
  
private

  def getHeadRevision(url)

    revision = nil
    out = Command.call("svn info #{url}")
    out.each_line do |line|
      if line.index("Revision:") != nil then
        line.slice!("Revision:")
        revision = line.strip
        break
      end
    end
    return revision
  end
  
end