require 'rfetch'

container_0 = Container.new(
	SvnProvider.new("svn://10.40.38.84:3690/cppdemo/trunk", SvnProvider::HEAD_REVISION)
)
project_0_0 = Project.new("Dummy")
container_0.projects << project_0_0
project_0_1 = Project.new("Logger")
container_0.projects << project_0_1

container_1 = Container.new(
	SvnProvider.new("svn://10.40.38.84:3690/cppdemo/branches/test1", SvnProvider::HEAD_REVISION)
)
project_1_0 = Project.new("FooLib")
	project_1_0.localname = "FooLib1"
container_1.projects << project_1_0
project_1_1 = Project.new("FooLib2")
container_1.projects << project_1_1

set = ProjectSet.new("..")
	set.containers << container_0
	set.containers << container_1
RFetch2Rake.new(set)
