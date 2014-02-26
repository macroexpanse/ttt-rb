class GameState
  attr_accessor :current_player, :ai_value, :cells, :moves, :turn

  def initialize(current_player, cells, turn)
    self.current_player = current_player
    self.ai_value = current_player.name == 'ai' ? current_player.value : current_player.opposite_value
    self.cells = cells
    self.moves = []
    self.turn = turn
  end

  def final_state?(winning_cell_results = winning_cells)
    winning_cell_results || draw?(winning_cell_results)
  end

  def draw?(winning_cell_results)
    values = cells.collect { |cell| cell.value }
    values.compact.size == 9 && winning_cell_results.nil?
  end

  def winning_cells
    @winner = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]].select { |positions| winning_positions?(cells, positions) }.compact.first
      [cells[@winner[0]], cells[@winner[1]], cells[@winner[2]]] rescue nil
  end

  def winning_positions?(cells, positions)
    cells[positions[0]].value == cells[positions[1]].value && cells[positions[1]].value == cells[positions[2]].value && cells[positions[2]].value != nil
  end

end
