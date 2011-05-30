require 'rfetch'

trunk = ProjectSet.new("trunk")
trunk1 = Container.new("SVN", "svn://10.40.38.84/rfetch1/trunk")
trunk1.projects << Project.new("Dummy")
trunk1.projects << Project.new("FooLib")
trunk1.projects << Project.new("FooLib2")
trunk.containers << trunk1
trunk2 = Container.new("SVN", "svn://10.40.38.84/rfetch2/trunk")
trunk2.projects << Project.new("Logger")
trunk.containers << trunk2

branch = ProjectSet.new("branch")
branch1 = Container.new("SVN", "svn://10.40.38.84/rfetch1/branches/branch1")
branch1.projects << Project.new("Dummy")
branch1.projects << Project.new("FooLib")
branch1.projects << Project.new("FooLib2")
branch.containers << branch1
branch.containers << trunk2

RFetch2Rake.new([trunk, branch])