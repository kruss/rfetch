require "rfetch/provider/generic_provider"
require "rfetch/util/command"

class CvsProvider < GenericProvider
  PROVIDER_NAME = "CVS"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    #nothing
  end
  
protected

  def checkoutProject(root, url, project, revision)
    cd root do
      out = Command.call("cvs -d #{url} checkout -r #{revision} -d #{project.localname} #{project.name}")
      out.each_line do |line|
        @output.log(project.localname, line)
      end
    end
  end

  def exportProject(root, url, project, revision)
    cd root do
      out = Command.call("cvs -d #{url} export -r #{revision} -d #{project.localname} #{project.name}")
      out.each_line do |line|
        @output.log(project.localname, line)
      end
    end
  end
  
  def updateProject(root, url, project, revision)
    cd root do
      out = Command.call("cvs -d #{url} update -r #{revision} -d #{project.localname}")
      out.each_line do |line|
        @output.log(project.localname, line)
      end
    end
  end
  
end