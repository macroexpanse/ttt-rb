class GameState
  attr_accessor :human_player, :current_player, :cells, :moves, :rank

  def initialize(current_player, cells)
    self.current_player = current_player 
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
    if current_player == 'X'
      ranks.max
    else
      ranks.min
    end
  end

  def final_state_rank
    if final_state?
      return 0 if draw?
      winner == 'X' ? 1 : -1
    end
  end

  def final_state?
    winner || draw?
  end

  def draw?
    values = cells.collect { |cell| cell.value }
    values.compact.size == 9 && winner.nil?
  end

  def winner
    @winner = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]].collect { |positions|
        ( cells[positions[0]].value == cells[positions[1]].value &&
          cells[positions[1]].value == cells[positions[2]].value &&
          cells[positions[0]].value || nil)
      }.compact.first
  end
end
