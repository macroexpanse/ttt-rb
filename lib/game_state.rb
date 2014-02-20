class GameState
  attr_accessor :current_player, :ai_value, :cells, :moves, :rank

  def initialize(current_player, cells)
    self.current_player = current_player
    self.ai_value = current_player.name == 'ai' ? current_player.value : current_player.opposite_value
    self.cells = cells
    self.moves = []
  end

  def next_move
    moves.max { |a, b| a.rank <=> b.rank }
  end

  def rank 
    @rank ||= final_state_rank || intermediate_state_rank
  end

  def intermediate_state_rank
    ranks = moves.collect { |game_state| game_state.rank }
    if current_player.name == 'ai'
      ranks.max
    else
      ranks.min
    end
  end

  def final_state_rank
    if final_state?
      return 0 if draw?
      if winning_cells.first.value == ai_value
        winning_cells.map { |winning_cell| winning_cell.win = true }
        1
      else
        -1
      end
    end
  end

  def final_state?
    winning_cells || draw?
  end

  def draw?
    values = cells.collect { |cell| cell.value }
    values.compact.size == 9 && winning_cells.nil?
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
      [2, 4, 6]].select { |positions|
        ( cells[positions[0]].value == cells[positions[1]].value &&
          cells[positions[1]].value == cells[positions[2]].value &&
          cells[positions[0]].value)
      }.compact.first
      [cells[@winner[0]], cells[@winner[1]], cells[@winner[2]]] rescue nil
  end
end
