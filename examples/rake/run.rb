require "rake"
sh "cls"

puts "\n### INFO ###\n"
sh "rake"
sh "rake -T"

puts "\n### PULL (CHECKOUT) ###\n"
sh "rake pull"

puts "\n### PULL (UPDATE) ###\n"
sh "rake pull"

puts "\n### PULL (NOUPDATE) ###\n"
FileUtils.rm_rf("Dummy")
sh "rake pull-noupdate"

puts "\n### CLEAN ###\n"
sh "rake clean"
