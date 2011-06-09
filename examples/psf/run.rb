require "rake"
sh "cls"

puts "\n### INFO (GEM) ###\n"
sh "rfetch"

puts "\n### CONVERT (SVN) ###\n"
sh "rfetch psf2rake -f projectSetSVN.psf -o rakefile.rb -r svn://10.40.38.84:3690/cppdemo/branches/test1=75"

puts "\n### INFO (RAKE) ###\n"
sh "rake"
sh "rake -T"

puts "\n### PULL (CHECKOUT) ###\n"
sh "rake pull"

puts "\n### CLEAN ###\n"
sh "rake clean"
FileUtils.rm("rakefile.rb")

puts "\n### CONVERT (CVS) ###\n"
sh "rfetch psf2rake -f projectSetCVS.psf -o rakefile.rb -u cvs.test1:443/data/var/lib/cvs=extssh:foo@cvs.test1:443/data/var/lib/cvs,cvs.test2:443/data/var/lib/cvs=extssh:foo@cvs.test2:443/data/var/lib/cvs"

puts "\n### INFO (RAKE) ###\n"
sh "rake"
sh "rake -T"

#puts "\n### PULL (CHECKOUT) ###\n"
#sh "rake pull"

puts "\n### CLEAN ###\n"
sh "rake clean"
FileUtils.rm("rakefile.rb")