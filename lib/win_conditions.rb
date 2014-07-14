class WinConditions
  attr_reader :board_height

  def initialize(args)
    @board_height = args[:board_height]
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

  private

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
