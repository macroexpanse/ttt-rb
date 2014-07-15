class Rules
  attr_reader :win_conditions

  def initialize(args)
    @win_conditions = args[:win_conditions]
  end

  def game_over?(board)
    get_winning_cells(board) || draw?(board)
  end

  def draw?(board)
    board.empty_cells.size == 0 && get_winning_cells(board).nil?
  end

  def get_winning_cells(board)
    winning_combination = winning_combination(board)
    winning_cells = winning_cells_from_winning_combination(winning_combination, board)
    if winning_cells
      winning_cells.map { |cell| cell.is_winner }
    end
    winning_cells
  end

  private

  def winning_combination(board)
    winning_combination = win_conditions.winning_combinations.detect do |combination|
      combination_is_winner?(combination, board)
    end
  end

  def combination_is_winner?(positions, board)
    unless board.cell_empty?(positions[0])
      positions.each_cons(2) do |current_position, next_position|
        comparison = board.value_for_cell(current_position) == board.value_for_cell(next_position)
        return false if comparison == false
      end
      true
    end
  end

  def winning_cells_from_winning_combination(winning_combination, board)
    winning_cells = []
    (0..board.height - 1).inject([]) do |winning_cells, i|
      winning_cells << board.cells[winning_combination[i]] rescue return
    end
  end
end
