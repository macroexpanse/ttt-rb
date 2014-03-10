class GameState

  attr_reader :cells

  def initialize(ai_player, human_player, current_player, cells, turn)
    @ai_player = ai_player
    @human_player = human_player
    @current_player = current_player
    @cells = cells
    @moves = []
    @turn = turn
  end

  def final_state?(winning_cell_results = get_winning_cells)
    winning_cell_results || draw?(winning_cell_results)
  end

  def draw?(winning_cell_results)
    values = @cells.select { |cell| cell.value != nil }
    values.size == 9 && winning_cell_results.nil?
  end

  def get_winning_cells
    if get_board_size == 9
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
      [2, 4, 6]].detect { |positions| winning_positions?(positions) }
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
      [3, 6, 9, 12]].detect { |positions| winning_positions?(positions) }
      [@cells[winner[0]], @cells[winner[1]], @cells[winner[2]], @cells[winner[3]]] rescue nil
  end

  def winning_positions?(positions)
    unless @cells[positions[0]].value.nil?
      positions.each_cons(2) do |current_position, next_position|
        comparison = (@cells[current_position].value == @cells[next_position].value) 
        return false if comparison == false
      end
      true
    end
  end
  
  def fill_cell(cell_id)
    @cells[cell_id].value = @current_player.value
  end
  
  def forceable_turn?
    @turn < (get_board_height - 1) && @current_player.name == 'ai'
  end

  def fill_random_corner_cell
    corner_cells = get_corner_cells
    unfilled_corner_cell = corner_cells.shuffle.detect { |cell| cell.value.nil? }
    fill_cell(unfilled_corner_cell.id)
  end

  def get_corner_cells
    board_height = get_board_height
    board_size = get_board_size
    corner_cells = [
      @cells[board_height - board_height],
      @cells[board_height - 1], 
      @cells[board_size - board_height],
      @cells[board_size - 1]
     ]
  end
  
  def get_board_size
    @cells.count 
  end

  def get_board_height
    Math.sqrt(get_board_size)
  end 

  def get_best_possible_move
    @moves.max { |a, b| a.rank <=> b.rank }
  end

  def rank
    if final_state?
      final_state_rank
    else
      intermediate_state_rank * 0.9
    end
  end

  def intermediate_state_rank
    ranks = collect_ranks_of_possible_moves
    if current_player_is_ai?
      ranks.max || 0
    else
      ranks.min || 0
    end
  end

  def final_state_rank
    winning_cell_results = get_winning_cells
    return 0 if draw?(winning_cell_results)
    if winning_cells_are_ai_cells?(winning_cell_results)
      set_win_on_winning_cells(winning_cell_results)
      1
    else
      -1
    end
  end

  def cell_empty?(user_input)
    @cells[user_input].value.nil?
  end

  def initialize_next_game_state(cell_id)
    next_cells = duplicate_cells
    fill_next_cell(cell_id, next_cells)
    increment_turn
    next_player = switch_current_player
    GameState.new(@ai_player, @human_player, next_player, next_cells, @turn)
  end

  def duplicate_cells
    @cells.collect { |cell| cell.dup } 
  end

  def fill_next_cell(cell_id, next_cells)
    next_cells[cell_id].value = @current_player.value
  end

  def increment_turn
    @turn += 1
  end

  def switch_current_player
    @ai_player == @current_player ? @human_player : @ai_player
  end

  def current_player_is_ai?
    @current_player.name == 'ai'
  end

  def current_player_is_human?
    @current_player.name == 'human'
  end

  def winning_cells_are_ai_cells?(winning_cell_results)
    winning_cell_results.first.value == @ai_player.value
  end

  def collect_ranks_of_possible_moves
    @moves.collect { |game_state| game_state.rank }
  end

  def set_win_on_winning_cells(winning_cell_results)
    winning_cell_results.map { |winning_cell| winning_cell.win = true }
  end

  def add_next_game_state_to_possible_moves(next_game_state)
    @moves << next_game_state
  end
  
  def convert_cells_to_array
    array = []
    number_of_cells = get_board_size 
    height = Math.sqrt(number_of_cells)
    @cells.each_with_index do |cell, index|
      value = cell.value
      array << value
    end
    array
  end

  def count_moves
    @moves.count
  end

end
