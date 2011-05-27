
require "rake"
require "optparse"
require "util/logger"

$AppName = "rfetch"
$AppVersion = "0.1.0"
$AppOutput = ".rfetch"
$AppOptions = {}

class RFetch

	def initialize()
		setOptions()
	end
	
	# run unit-tests
	def run()

		if validOptions() then
			createOutputFolder()
			Logger.setLogfile($AppOptions[:output]+"/"+$AppName+".log")
			Logger.info $AppName+" ("+$AppVersion+")"
			
			begin
				runApplication()
			rescue => exception
				Logger.trace exception
				exit(-1)
			end
			exit(0)
		else
		
			puts "try "+$AppName+" --help"
			exit(-1)
		end
	end
	
private
	
	def setOptions()
		$AppOptions.clear
		
		# parse explicit options
		optparse = OptionParser.new do |opts|
			opts.banner = $AppName+" options:"
			
			$AppOptions[:file] = nil
			opts.on("-f", "--file FILE", "rps-file name") do |option|
				$AppOptions[:file] = option
		  end
    
        # for remote rps-files
        $AppOptions[:nature] = nil
        opts.on("-n", "--nature NATURE", "remote rps-file nature") do |option|
          $AppOptions[:nature] = option
        end
    		
        $AppOptions[:revision] = nil
        opts.on("-r", "--revision REVISION", "remote rps-file revision") do |option|
          $AppOptions[:revision] = option
        end
      
      $AppOptions[:directory] = nil
      opts.on("-d", "--directory DIRECTORY", "local target directory") do |option|
        $AppOptions[:directory] = option
      end
      
			opts.on("-h", "--help", "Display this screen") do
				puts opts
				exit(0)
			end
		end
		optparse.parse!
		
		# set implicit options
		if 
			ARGV.size == 1
		then
			$AppOptions[:command] = ARGV[0]
	  end
  
    if 
      $AppOptions[:file] == nil
    then
      $AppOptions[:file] = $AppName+".rps" # TODO make constant
    end

    if 
      $AppOptions[:directory] != nil
    then
      $AppOptions[:directory] = cleanPath($AppOptions[:directory])
    else
      $AppOptions[:directory] = Dir.getwd
    end
		$AppOptions[:output] = $AppOptions[:directory]+"/"+$AppOutput

    if 
      $AppOptions[:nature] != nil && $AppOptions[:revision] == nil
    then
      $AppOptions[:revision] = "HEAD" # TODO make constant
    end

    if 
      $AppOptions[:nature] != nil && $AppOptions[:revision] != nil
    then
      $AppOptions[:type] = "REMOTE" # TODO make constant
    else
      $AppOptions[:type] = "LOCAL" # TODO make constant
    end
  
	end
	
	def validOptions()
	
		if 
      $AppOptions[:file] != nil && 
			$AppOptions[:command] != nil && 
			$AppOptions[:directory] != nil && 
			FileTest.directory?($AppOptions[:directory]) 
		then
			return true
		else
			return false
		end
	end
	
	def cleanPath(path)
	
		if path == "." then
			return Dir.getwd
		elsif path == ".." then
			return Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		else
			return Pathname.new(path.gsub(/\\/, "/")).cleanpath.to_s
		end
	end
	
	def createOutputFolder

		deleteOutputFolder
		FileUtils.mkdir_p($AppOptions[:output])
	end
	
	def deleteOutputFolder
	
		if FileTest.directory?($AppOptions[:output]) then 
			FileUtils.rm_rf($AppOptions[:output])
		end
	end

	def runApplication()
		
		# TODO
    puts "rps: "+$AppOptions[:file]
    puts "type: "+$AppOptions[:type]
    puts "command: "+$AppOptions[:command]
    puts "directory: "+$AppOptions[:directory]
  
	end
end