require "rfetch/command/generic_command"
require "rfetch/util/command"
require "fileutils"

class FetchCommand < GenericCommand

  def initialize()
    super("psf4date", "Fetch a psf-file for date (SVN)")
  end
  
  def initOptions()
  
    @parse.on("-p", "--psf URL", "URL of psf to fetch") do |param|
      @options[:PsfUrl] = param
    end
    @parse.on("-d", "--date DATE", "DATE in z-time: yyyy-mm-ddThh:mm:ss.uuuuuuZ (optional)") do |param|
      @options[:PsfDate] = param
    end
    @parse.on("-t", "--target PATH", "PATH to target-folder (optional)") do |param|
      @options[:TargetDir] = param
    end
    @parse.on("-e", "--export", "perform export (optional)") do
      @options[:ExportMode] = true
    end
    
  end
  
  def validOptions()
    
    if @options[:PsfUrl] != nil then
      return true
    else
      return false
    end
  end
  
  def runCommand()

    psfUrl = @options[:PsfUrl]
    psfDate = @options[:PsfDate]
    if psfDate == nil then
      psfDate = [Time.new].collect { |t|  "#{t.year}-#{t.month}-#{t.day}T#{t.hour}:#{t.min}:#{t.sec}.#{t.usec}Z" }.first
    end
    targetDir = @options[:TargetDir]
    if targetDir == nil then
      targetDir = Dir.getwd+"/psf4date"
    end
    exportMode = @options[:ExportMode]
    if exportMode == nil then
      exportMode = false
    end
    
    puts $PROMPT+" #{@name}: #{psfUrl} (#{psfDate}) -> #{targetDir}#{ exportMode ? " (EXPORT)" : "" }"
    fetchPsf(psfUrl, psfDate, targetDir, exportMode)
     
 end
 
private

  def fetchPsf(psfUrl, psfDate, targetDir, exportMode)
    psfFile = "#{targetDir}/projects.psf"
    rakeFile = "#{targetDir}/projects.rb"
    
    # clean target
    if File.directory?(targetDir) then
      puts $PROMPT+" clean: #{targetDir}"
      FileUtils.rm_rf(targetDir)
    end
    FileUtils.mkdir_p(targetDir)
    
    # export psf
    puts $PROMPT+" export: #{psfUrl} (#{psfDate})"
    Command.call("svn export -r \"{#{psfDate}}\" #{psfUrl} #{psfFile}")
    
    # analyse psf
    puts $PROMPT+" analyse: #{psfFile}"
    containers = Array.new
    lines = IO.readlines("#{psfFile}")
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
    puts $PROMPT+" convert: #{psfFile} -> #{rakeFile}"
    cmd = "rfetch psf2rake -f #{psfFile} -o #{rakeFile}"
    if containers.size > 0 then
      cmd << " -r "
      containers.each do |url|
        cmd << "#{url}={#{psfDate}}"
        if !url.eql?(containers.last)  then
          cmd << ","
        end
      end
    end
    Command.call(cmd)
    
    # pull psf
    FileUtils.cd targetDir do
        puts $PROMPT+" pull: #{rakeFile}"
        Command.call("rake -f projects.rb pull#{exportMode ? "-export" : ""}")
#      if !system("rake -f projects.rb pull#{exportMode ? "-export" : ""}") then
#        raise "error while fetching psf"
#      end
    end
  end
  
end
