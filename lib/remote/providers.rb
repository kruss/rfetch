
class Providers
  
  def Providers.getProvider(nature)
    
    if nature.eql?(SvnProvider::NATURE)
      return SvnProvider.new()
    end
    raise "unsupported nature #{nature}"
  end
end