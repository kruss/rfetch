require "rake"

sh "cls"
puts "\n### SHOW HELP ###\n"
sh "rfetch"

puts "\n### CONVERT PSF ###\n"
sh "rfetch psf2rake -f projectSet.psf -o rakefile.rb"

puts "\n### PERFORM CHEKOUT ###\n"
sh "rake pull"

puts "\n### PERFORM DROP ###\n"
sh "rake drop"
FileUtils.rm("rakefile.rb")