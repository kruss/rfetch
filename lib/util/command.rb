
class Command
  
  def Command.call(cmd)
    if $VERBOSE then
      puts $PROMPT+" CMD: '#{cmd}'"
    end
    out = `#{cmd} 2>&1`
    res = $?.to_i
    if res != 0 then
      message = "CMD failed: '#{cmd}' (#{res}) [\n#{out}]"
      if $STRICT then
        raise message
      else
        puts $PROMPT+" !!! Error !!! #{message}"
      end      
    elsif $VERBOSE then
      puts $PROMPT+" => (#{res}) [\n#{out}]"
    end
    return out
  end
  
end