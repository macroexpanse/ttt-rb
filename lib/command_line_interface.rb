require_relative '../spec/spec_helper'

class CommandLineInterface 

  GREETING = "Welcome to ttt-rb, are you ready to play?"
  FAREWELL = "Ok, thanks for playing!"
  NEXT_MOVE = "Enter an integer to select which cell you would like to fill next (0-8)"
  INVALID_MOVE = "That cell is already filled. Please select a different cell (0-8)"

  def initialize(ai)
    @ai = ai
  end

  def output_message(string) 
    puts string
  end

  def accept_input
    gets.chomp.downcase
  end

  def draw_board(game_state)
    board = ""
    array_of_cell_values = convert_cells_to_array(game_state.cells)
    array_of_cell_values.each_with_index do |value, index|
      value = ' ' if value.nil?
      board << value
      if (index + 1) % 3 != 0
        board << "|"
      else
        board << "\n"
      end 
    end
    board
  end

end
