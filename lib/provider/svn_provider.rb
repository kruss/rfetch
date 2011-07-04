require "provider/generic_provider"

class SvnProvider < GenericProvider
  PROVIDER_NAME = "SVN"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    
    if @revision.eql?(HEAD_REVISION) then
      @revision = getHeadRevision(@url)
      puts $PROMPT+" adjust: #{@url} (#{HEAD_REVISION}) -> (#{@revision})"
    end
  end
  
protected

  def checkoutProject(root, url, project, revision)
    url = url+"/"+project.name
    path = root+"/"+project.localname
    
    out = call("svn -r #{revision} checkout #{url}@#{revision} #{path}")
    out.each_line do |line|
      @output.log(project.localname, line)
    end
  end

  def updateProject(root, url, project, revision)
    path = root+"/"+project.localname
    
    out = call("svn -r #{revision} update #{path}")
    out.each_line do |line|
      @output.log(project.localname, line)
    end
  end
  
private

  def getHeadRevision(url)

    revision = nil
    out = call("svn info #{url}")
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