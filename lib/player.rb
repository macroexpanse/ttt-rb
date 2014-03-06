class Player
   
  attr_accessor :name, :value, :current_player

  def initialize(data)
    self.name = data.fetch(:name)
    self.value = data.fetch(:value)
    self.current_player = data[:current_player]
  end

  def opposite_value
    value == 'X' ? 'O' : 'X'
  end
  
  def opposite_name
    name == 'human' ? 'ai' : 'human'
  end

  def is_ai?
    name == 'ai'
  end

  def is_human?
    name == 'human'
  end

end
