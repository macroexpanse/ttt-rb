class GameState
  attr_accessor :board, :ai_player, :human_player, :turn, :rules

  def initialize(args)
    @board = args[:board]
    @ai_player = args[:ai_player]
    @human_player = args[:human_player]
    @rules = args[:rules]
    @turn = args[:turn]
  end

  def forceable_turn?
    @turn < (board_height - 1)
  end

  def board_height
    board.height
  end

  def board_size
    board.size
  end

  def empty_cells
    board.empty_cells
  end

  def duplicate_with_move(id, value)
    dup = Marshal.load(Marshal.dump(self))
    dup.fill_cell(id, value)
    dup
  end

  def duplicate_cells
    cells.collect { |cell| cell.dup }
  end

  def cells
    board.cells
  end

  def cells=(cells)
    board.cells = cells
  end

  def fill_cell(id, value)
    board.fill_cell(id, value)
  end

  def fill_human_cell(id)
    fill_cell(id, human_value)
  end

  def human_value
    human_player.value
  end

  def fill_ai_cell(id)
    fill_cell(id, ai_value)
  end

  def ai_value
    ai_player.value
  end

  def cell_empty?(id)
    board.cell_empty?(id)
  end

  def value_for_cell(id)
    board.cell(id)
  end

  def get_middle_cell
    board.middle_cell
  end

  def fill_random_corner_cell
    corner_cells = get_corner_cells
    unfilled_corner_cell = corner_cells.shuffle.detect { |cell| cell.value.nil? }
    fill_ai_cell(unfilled_corner_cell.id)
  end

  def get_corner_cells
    corner_cells = [
      cells[board_height - board_height],
      cells[board_height - 1],
      cells[board_size - board_height],
      cells[board_size - 1]
     ]
  end

  def game_over?
    rules.game_over?(board)
  end

  def draw?
    rules.draw?(board)
  end

  def winning_cells
    rules.winning_cells(board)
  end

  def winning_cells_are_ai_cells?
    winning_cells.first.value == ai_value
  end

  def increment_turn
    @turn += 1
  end

  def convert_cells_to_array
    board.convert_cells_to_array
  end
end
