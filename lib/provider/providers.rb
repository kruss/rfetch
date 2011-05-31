
class Providers
  
  def Providers.getProvider(nature)
    
    if nature.name.eql?(SvnProvider::NAME)
      return SvnProvider.new()
    end
    raise "unsupported nature #{nature.name}"
  end
end