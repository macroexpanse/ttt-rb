require_relative '../spec/spec_helper'

class CommandLineInterface 

  GREETING = "Welcome to ttt-rb, are you ready to play?"

  def initialize(ai)
    @ai = ai
  end

  def output_message(string) 
    puts string
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
    puts board
  end

  def run(user_input)
    user_input == 'y' ? initialize_console_game : kill
  end

  def initialize_console_game
    @ai.generate('X', 3)
  end

end
