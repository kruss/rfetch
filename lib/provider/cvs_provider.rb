require "provider/generic_provider"

class CvsProvider < GenericProvider
  PROVIDER_NAME = "CVS"
  HEAD_REVISION = "HEAD"
  
  def getName()
    return PROVIDER_NAME
  end
  
  def adjust()
    #nothing
  end
  
protected

  def checkoutProject(root, url, project, revision)

    cd root do
      out = IO.popen("cvs -d #{url} checkout -r #{revision} -d #{project.localname} #{project.name}")
      out.readlines.each do |line|
        @output.log(project.localname, line)
      end
    end
  end

  def updateProject(root, url, project, revision)
    
    cd root do
      out = IO.popen("cvs -d #{url} update -r #{revision} -d #{project.localname}")
      out.readlines.each do |line|
        @output.log(project.localname, line)
      end
    end
  end
  
end