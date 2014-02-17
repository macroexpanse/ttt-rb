class GameState
  attr_accessor :current_player, :cells, :moves

  def initialize(current_player, cells)
    self.current_player = current_player
    self.cells = cells
    self.moves = []
  end
end
