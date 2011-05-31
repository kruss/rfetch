require 'rfetch'

container = Container.new(
  SvnProvider.new("svn://10.40.38.84/cppdemo/trunk", SvnProvider::HEAD_REVISION)
)
container.projects << Project.new("Dummy")
container.projects << Project.new("FooLib")
container.projects << Project.new("FooLib2")
container.projects << Project.new("Logger")

set = ProjectSet.new(".")
set.containers << container

RFetch2Rake.new(set)