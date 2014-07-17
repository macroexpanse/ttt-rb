class Rules
  attr_reader :board

  def initialize(args)
    @board = args[:board]
    @winning_combinations = winning_combinations
  end

  def game_over?
    winning_cells || draw?
  end

  def draw?
    board.empty_cells.size == 0 && winning_cells.nil?
  end

  def winning_cells
    winning_cells = nil
    @winning_combinations.each do |combination|
      cells = board.cells.select { |cell| combination.include?(cell.id) }
      values = cells.collect { |cell| cell.value }
      if values.all? { |value| value == "X" } || values.all? { |value| value == "O"}
        winning_cells = cells
      end
    end
    winning_cells
  end

  private

  def board_height
    board.height
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

end
