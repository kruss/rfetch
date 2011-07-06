require "rake"
sh "cls"

cd "../.." do
  sh "rake install"
end

puts "\n### INFO (RAKE) ###\n"
sh "rake"
sh "rake -T"

puts "\n### PULL (EXPORT) ###\n"
sh "rake pull-export"

puts "\n### CLEAN ###\n"
sh "rake clean"

puts "\n### PULL (CHECKOUT) ###\n"
sh "rake pull"

puts "\n### PULL (UPDATE) ###\n"
sh "rake pull"

puts "\n### PULL (NOUPDATE) ###\n"
FileUtils.rm_rf("Dummy")
sh "rake pull-noupdate"

puts "\n### CLEAN ###\n"
sh "rake clean"
