class Player
   
  attr_accessor :name, :value

  def initialize(data)
    self.name = data.fetch(:name)
    self.value = data.fetch(:value)
  end
  
  def opposite_player
    Player.new(:name => self.opposite_name, :value => self.opposite_value)
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
