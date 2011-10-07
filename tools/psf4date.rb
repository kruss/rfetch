require "fileutils"

# utility-script to fetch a SVN psf for given date
# params:
#  psf:     url of psf
#  date:    date to fetch psf, eg: "2011-11-06T12:00:00.000000Z"
#  folder:  target folder to fetch the psf
#  export:  if set perform export only

psf = nil
date = [Time.new].collect { |t|  "#{t.year}-#{t.month}-#{t.day}T#{t.hour}:#{t.min}:#{t.sec}.#{t.usec}Z" }.first
folder = Dir.getwd+"/psf"
export = false

# get args
if ARGV.size > 0 then
  psf = ARGV[0]
else
  raise "call with: psf-url [date('yyyy-mm-ddThh:mm:ss.uuuuuuZ') [target-folder ['export']]]"
end
if ARGV.size > 1 then
  date = ARGV[1]
end
if ARGV.size > 2 then
  folder = ARGV[2]
end
if ARGV.size > 3 then
  export = ARGV[3].eql?("export")
end

# clean target
if File.directory?(folder) then
  FileUtils.rm_rf(folder)
end
FileUtils.mkdir_p(folder)

# export psf
system("svn export -r \"{#{date}}\" #{psf} #{folder}/projects.psf")

# analyse psf
containers = Array.new
lines = IO.readlines("#{folder}/projects.psf")
lines.each do |line|
  if line.index("<project") != nil then
      segments = line.split(",")
      project_url = segments[1]
      url_segments = project_url.split("/")
      project_name = url_segments[url_segments.size()-1]
      url = project_url.chomp("/"+project_name)
    if !containers.include?(url) then
      containers << url
    end
  end
end

# convert psf
cmd = "rfetch psf2rake -f #{folder}/projects.psf -o #{folder}/projects.rb"
if containers.size > 0 then
  cmd << " -r "
  containers.each do |url|
    cmd << "#{url}={#{date}}"
    if !url.eql?(containers.last)  then
      cmd << ","
    end
  end
end
puts cmd
system(cmd)

# pull psf
FileUtils.cd folder do
  system("rake -f projects.rb pull#{export ? "-export" : ""}")
end