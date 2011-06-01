require 'rfetch'

container1 = Container.new(
  SvnProvider.new("svn://10.40.38.84/cppdemo/trunk", SvnProvider::HEAD_REVISION)
)
container1.projects << Project.new("Dummy")
container1.projects << Project.new("Logger")

container2 = Container.new(
  SvnProvider.new("svn://10.40.38.84/cppdemo/branches/test1", "75")
)
  foo1 = Project.new("FooLib")
  foo1.localname = "FooLib1"
container2.projects << foo1
container2.projects << Project.new("FooLib2")

set = ProjectSet.new(".")
set.containers << container1
set.containers << container2
set.pack()

RFetch2Rake.new(set)