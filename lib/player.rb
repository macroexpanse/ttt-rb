class Player
  attr_reader :name, :value

  def initialize(data)
    @name = data[:name]
    @value = data[:value]
  end

  def opposite_value
    value == 'X' ? 'O' : 'X'
  end
end
