class Player
   
  attr_accessor :name, :value

  def initialize(data)
    self.name = data.fetch(:name)
    self.value = data.fetch(:value)
  end

  def opposite_value
    value == 'X' ? 'O' : 'X'
  end
  
  def opposite_name
    name == 'human' ? 'ai' : 'human'
  end

end
