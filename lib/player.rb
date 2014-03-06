class Player
   
  attr_accessor :name, :value 

  def initialize(data)
    self.name = data.fetch(:name)
    self.value = data.fetch(:value)
  end

end
