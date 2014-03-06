class Player
   
  attr_accessor :name, :value, :current_player

  def initialize(data)
    self.name = data.fetch(:name)
    self.value = data.fetch(:value)
    self.current_player = data[:current_player]
  end

end
