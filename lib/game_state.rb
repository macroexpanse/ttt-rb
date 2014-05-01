class GameState

  attr_accessor :cells, :ai_player, :human_player, :turn

  def initialize(ai_player, human_player, cells, turn)
    @ai_player = ai_player
    @human_player = human_player
    @cells = cells
    @turn = turn
  end

  def forceable_turn?
    @turn < (get_board_height - 1)
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

  def duplicate_with_move(cell_id, value)
    dup = self.dup
    dup.cells = duplicate_cells
    dup.fill_cell(cell_id, value)
    dup
  end

  def duplicate_cells
    @cells.collect { |cell| cell.dup }
  end

  def fill_cell(cell_id, value)
    @cells[cell_id].value = value
  end

  def fill_ai_cell(cell_id)
    fill_cell(cell_id, @ai_player.value)
  end

  def final_state?(winning_cell_results)
    winning_cell_results || draw?(winning_cell_results)
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

  def get_cell_value(cell_id)
    @cells[cell_id].value
  end

  def get_middle_cell
    @cells[(get_board_size - 1) / 2]
  end

  def fill_random_corner_cell
    corner_cells = get_corner_cells
    unfilled_corner_cell = corner_cells.shuffle.detect { |cell| cell.value.nil? }
    fill_ai_cell(unfilled_corner_cell.id)
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

  def value_is?(name, value)
    instance_variable_get("@#{name}_player").value == value
  end

  def convert_cells_to_array
    array = []
    @cells.each_with_index do |cell, index|
      value = cell.value
      array << value
    end
    array
  end

end
