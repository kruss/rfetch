require "rake"
sh "cls"

puts "\n### INFO (GEM) ###\n"
sh "rfetch"

puts "\n### CONVERT (SVN) ###\n"
sh "rfetch psf2rake -f projectSetSVN.psf -o rakefile.rb"

puts "\n### INFO (RAKE) ###\n"
sh "rake"
sh "rake -T"

puts "\n### PULL (CHECKOUT) ###\n"
sh "rake pull"

puts "\n### CLEAN ###\n"
sh "rake clean"
FileUtils.rm("rakefile.rb")

puts "\n### CONVERT (CVS) ###\n"
sh "rfetch psf2rake -f projectSetCVS.psf -o rakefile.rb"

puts "\n### INFO (RAKE) ###\n"
sh "rake"
sh "rake -T"

#puts "\n### PULL (CHECKOUT) ###\n"
#sh "rake pull"

puts "\n### CLEAN ###\n"
sh "rake clean"
FileUtils.rm("rakefile.rb")