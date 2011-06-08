require "rake"
sh "cls"

puts "\n### INFO ###\n"
sh "rfetch"

puts "\n### CONVERT ###\n"
sh "rfetch psf2rake -f projectSet.psf -o rakefile.rb"

puts "\n### PULL (CHECKOUT) ###\n"
sh "rake pull"

puts "\n### CLEAN ###\n"
sh "rake clean"
FileUtils.rm("rakefile.rb")