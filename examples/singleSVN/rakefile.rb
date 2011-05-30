require 'rfetch'

set = ProjectSet.new()

container = Container.new("SVN", "svn://10.40.38.84/cppdemo/trunk")
container.projects << Project.new("Dummy")
container.projects << Project.new("FooLib")
container.projects << Project.new("FooLib2")
container.projects << Project.new("Logger")
set.containers << container

RFetch2Rake.new(set)