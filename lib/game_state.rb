class GameState

  attr_accessor :cells, :human_player, :ai_player, :current_player, :turn

  def initialize(ai_player, human_player, current_player, cells, turn) 
    @ai_player = ai_player
    @human_player = human_player
    @current_player = current_player
    @cells = cells 
    @turn = turn 
  end

  def forceable_turn?
    @turn < (get_board_height - 1) && current_player_is?("ai") 
  end

  def get_board_height
    Math.sqrt(get_board_size).to_i
  end

  def get_board_size
    @cells.count
  end

  def empty_cells
    @cells.select { |cell| cell.value.nil? }
  end

  def duplicate_with_move(cell_index)
    dup = self.dup
    dup.cells = duplicate_cells
    dup.fill_cell(cell_index) 
    dup 
  end

  def duplicate_cells
    @cells.collect { |cell| cell.dup }
  end

  def switch_current_player
    @current_player = opposite_of_current_player
  end

  def opposite_of_current_player
    @ai_player == @current_player ? @human_player : @ai_player
  end

  def final_state?(winning_cell_results)
    !!winning_cell_results || draw?(winning_cell_results)
  end

  def draw?(winning_cell_results)
    empty_cells.size == 0 && winning_cell_results.nil?
  end

  def winning_cells_are_ai_cells?(winning_cells)
    winning_cells.first.value == @ai_player.value
  end

  def cell_empty?(user_input)
    @cells[user_input].value.nil?
  end

  def fill_cell(cell_id)
    @cells[cell_id].value = @current_player.value
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

  def increment_turn
    @turn += 1
  end

  def human_player_turn
    @current_player = @human_player
  end

  def ai_player_turn
    @current_player = @ai_player
  end

  def current_player_is?(name)
    @current_player.name == name
  end

  def set_winning_cells(winning_cell_results)
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

end
