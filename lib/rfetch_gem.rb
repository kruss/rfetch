# actions provided by the gem here

require "rfetch"

$Options = {}

class RFetchGem

	def initialize()
		setOptions()
	end
	
	# run unit-tests
	def run()

		if validOptions() then
			createOutputFolder()
			Logger.setLogfile($Options[:output]+"/"+$APP_NAME+".log")
			Logger.info $APP_NAME
			
			begin
				runApplication()
			rescue => exception
				Logger.trace exception
				exit(-1)
			end
			exit(0)
		else
		
			puts "try "+$APP_NAME+" --help"
			exit(-1)
		end
	end
	
private
	
	def setOptions()
		$Options.clear
		
		# parse explicit options
		optparse = OptionParser.new do |opts|
			opts.banner = $APP_NAME+" options:"
			
			$Options[:file] = nil
			opts.on("-f", "--file FILE", "rps-file name") do |option|
				$Options[:file] = option
		  end
        # for remote rps-files
        $Options[:nature] = nil
        opts.on("-n", "--nature NATURE", "remote rps-file nature") do |option|
          $Options[:nature] = option
        end
        $Options[:revision] = nil
        opts.on("-r", "--revision REVISION", "remote rps-file revision") do |option|
          $Options[:revision] = option
        end
      
      $Options[:directory] = nil
      opts.on("-d", "--directory DIRECTORY", "local target directory") do |option|
        $Options[:directory] = option
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
			$Options[:command] = ARGV[0]
	  end
  
    if 
      $Options[:file] == nil
    then
      $Options[:file] = $APP_NAME+".rps" # TODO make constant
    end

    if 
      $Options[:directory] != nil
    then
      $Options[:directory] = cleanPath($Options[:directory])
    else
      $Options[:directory] = Dir.getwd
    end
		$Options[:output] = $Options[:directory]+"/."+$APP_NAME

    if 
      $Options[:nature] != nil && $Options[:revision] == nil
    then
      $Options[:revision] = "HEAD" # TODO make constant
    end

    if 
      $Options[:nature] != nil && $Options[:revision] != nil
    then
      $Options[:type] = "REMOTE" # TODO make constant
    else
      $Options[:type] = "LOCAL" # TODO make constant
    end
  
	end
	
	def validOptions()
	
		if 
      $Options[:file] != nil && 
			$Options[:command] != nil && 
			$Options[:directory] != nil && 
			FileTest.directory?($Options[:directory]) 
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
		FileUtils.mkdir_p($Options[:output])
	end
	
	def deleteOutputFolder
	
		if FileTest.directory?($Options[:output]) then 
			FileUtils.rm_rf($Options[:output])
		end
	end

	def runApplication()
		
		# TODO
    puts "file: "+$Options[:file]+" ("+$Options[:type]+")"
    puts "command: "+$Options[:command]
    puts "directory: "+$Options[:directory]
  
	end
end