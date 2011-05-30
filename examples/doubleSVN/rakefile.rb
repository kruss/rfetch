require 'rfetch'

set = ProjectSet.new()

container1 = Container.new("SVN", "svn://10.40.38.84/rfetch1/trunk")
container1.projects << Project.new("Dummy")
container1.projects << Project.new("FooLib")
container1.projects << Project.new("FooLib2")
set.containers << container1

container2 = Container.new("SVN", "svn://10.40.38.84/rfetch2/trunk")
  logger = Project.new("Logger")
  logger.revision = "1234"
container2.projects << logger
set.containers << container2

RFetch2Rake.new(set)