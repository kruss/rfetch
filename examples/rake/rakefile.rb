require 'rfetch'

container1 = Container.new(
  SvnProvider.new("svn://10.40.38.84/cppdemo/trunk")
)
container1.projects \
  << Project.new("Dummy") \
  << Project.new("Logger")
  
container2 = Container.new(
  SvnProvider.new("svn://10.40.38.84/cppdemo/branches/test1", "75")
)
container2.projects \
  << Project.new("FooLib", "FooLib1") \
  << Project.new("FooLib2")
  
set = ProjectSet.new(".")
set.containers \
  << container1 \
  << container2
  
RFetch2Rake.new(set)