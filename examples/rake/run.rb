require "rake"

sh "cls"
puts "\n### SHOW INFO & TASKS ###\n"
sh "rake"
sh "rake -T"

puts "\n### PERFORM CHEKOUT ###\n"
sh "rake pull"

puts "\n### PERFORM UPDATE ###\n"
sh "rake pull"

puts "\n### PERFORM CHEKOUT / NO-UPDATE ###\n"
FileUtils.rm_rf("Dummy")
sh "rake pull mode=keep"

puts "\n### SHOW STATUS ###\n"
file = File.new("Dummy/.project", "a")
file.syswrite("rfetch")
file.close
sh "rake status"

puts "\n### PERFORM REVERT ###\n"
sh "rake revert"

puts "\n### PERFORM DROP ###\n"
sh "rake drop"
