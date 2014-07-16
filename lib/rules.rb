class Rules
  attr_reader :board

  def initialize(args)
    @board = args[:board]
  end

  def game_over?
    get_winning_cells || draw?
  end

  def draw?
    board.empty_cells.size == 0 && get_winning_cells.nil?
  end

  def get_winning_cells
    winning_cells_from_winning_combination(winning_combination)
  end

  private

  def board_height
    board.height
  end

  def winning_combination
    winning_combination = winning_combinations.detect do |combination|
      combination_is_winner?(combination)
    end
  end

  def winning_combinations
    winning_combinations = []
    board_height.times do |i|
      winning_row_combination, winning_column_combination = [], []
      board_height.times do |ii|
        winning_row_combination << (i * board_height) + ii
        winning_column_combination << (ii * board_height) + i
      end
     winning_combinations << winning_row_combination << winning_column_combination
    end
    winning_combinations + [left_diagonal_win, right_diagonal_win]
  end

  def left_diagonal_win
    (0..board_height - 1).inject([]) do |diagonal, i|
      diagonal << i * (board_height + 1)
    end
  end

  def right_diagonal_win
    (0..board_height - 1).inject([]) do |diagonal, i|
      diagonal << (i + 1) * (board_height - 1)
    end
  end

  def combination_is_winner?(positions)
    unless board.cell_empty?(positions[0])
      positions.each_cons(2) do |current_position, next_position|
        comparison = board.value_for_cell(current_position) == board.value_for_cell(next_position)
        return false if comparison == false
      end
      true
    end
  end

  def winning_cells_from_winning_combination(winning_combination)
    winning_cells = []
    (0..board.height - 1).inject([]) do |winning_cells, i|
      winning_cells << board.cells[winning_combination[i]] rescue return
    end
  end

end
