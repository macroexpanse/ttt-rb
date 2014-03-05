class GameState

  def initialize(current_player, cells, turn)
    @current_player = current_player
    @ai_value = current_player.name == 'ai' ? current_player.value : current_player.opposite_value
    @cells = cells
    @moves = []
    @turn = turn
  end

  def final_state?(winning_cell_results = get_winning_cells)
    winning_cell_results || draw?(winning_cell_results)
  end

  def draw?(winning_cell_results)
    values = @cells.collect { |cell| cell.value }
    values.compact.size == 9 && winning_cell_results.nil?
  end

  def get_winning_cells
    if @cells.count == 9
      three_by_three_winning_cells
    else
      four_by_four_winning_cells
    end
  end

  def three_by_three_winning_cells
    winner = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]].select { |positions| three_by_three_winning_positions?(@cells, positions) }.compact.first
      [@cells[winner[0]], @cells[winner[1]], @cells[winner[2]]] rescue nil
  end

  def four_by_four_winning_cells
    winner = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [8, 9, 10, 11],
      [12, 13, 14, 15],
      [0, 4, 8, 12],
      [1, 5, 9, 13],
      [2, 6, 10, 14],
      [3, 7, 11, 15],
      [0, 5, 10, 15],
      [3, 6, 9, 12]].select { |positions| four_by_four_winning_positions?(@cells, positions) }.compact.first
      [@cells[winner[0]], @cells[winner[1]], @cells[winner[2]], @cells[winner[3]]] rescue nil
  end

  def three_by_three_winning_positions?(cells, positions)
    cells[positions[0]].value == cells[positions[1]].value && cells[positions[1]].value == cells[positions[2]].value && cells[positions[2]].value != nil
  end

  def four_by_four_winning_positions?(cells, positions)
    cells[positions[0]].value == cells[positions[1]].value && cells[positions[1]].value == cells[positions[2]].value && cells[positions[2]].value == cells[positions[3]].value && cells[positions[3]].value != nil
  end
  
  def fill_cell_from_user_input(user_input)
    @cells[user_input].value = @current_player.value
  end

  def increment_turn
    @turn += 1
  end
  
  def first_ai_turn?
    @turn == 1 && @current_player.name == 'ai'
  end
  
  def get_board_size
    @cells.count 
  end

  def get_best_possible_move(ai)
    @moves.max { |a, b| ai.rank(a) <=> ai.rank(b) }
  end

  def cell_empty?(user_input)
    @cells[user_input].value.nil?
  end

  def middle_empty?
    @cells[4].value.nil?
  end

  def top_left_corner_empty?
    @cells[0].value.nil?
  end
  
  def fill_middle_cell
    @cells[4].value = @ai_value
  end

  def fill_top_left_corner_cell
    @cells[0].value = @ai_value
  end

  def fill_bottom_left_corner_cell
    @cells[15].value = @ai_value
  end

  def current_player_is_ai?
    @current_player.is_ai?
  end

  def winning_cells_are_ai_cells?(winning_cell_results)
    winning_cell_results.first.value == @ai_value
  end

  def collect_ranks_of_possible_moves(ai)
    @moves.collect { |game_state| ai.rank(game_state) }
  end

  def set_win_on_winning_cells(winning_cell_results)
    winning_cell_results.map { |winning_cell| winning_cell.win = true }
  end

  def switch_player
    @current_player.opposite_player
  end

  def find_empty_cells_to_generate_game_tree(ai, next_player, alpha, beta, depth)
    @cells.each do |cell|
      if cell.value.nil?
        ai.generate_next_game_state(self, cell.id, next_player, alpha, beta, depth)
      end
    end
  end

  def duplicate_cells
    @cells.collect { |cell| cell.dup }
  end

  def fill_next_cell(cell_id, next_cells)
    next_cells[cell_id].value = @current_player.value
  end

  def add_next_game_state_to_possible_moves(next_game_state)
    @moves << next_game_state
  end
  
  def convert_cells_to_array
    array = []
    number_of_cells = @cells.count 
    height = Math.sqrt(number_of_cells)
    @cells.each_with_index do |cell, index|
      value = cell.value
      array << value
    end
    array
  end

  def serve_cells_to_front_end
    @cells
  end

  def count_moves
    @moves.count
  end

end
