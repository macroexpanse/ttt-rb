require_relative '../spec/spec_helper'

class CommandLineInterface 
    GREETING = "Welcome to ttt-rb, are you ready to play?"
    FAREWELL = "Ok, thanks for playing!"
    NEXT_MOVE = "Enter an integer to select which cell you would like to fill next (0-8)"
    INVALID_MOVE = "That cell is already filled. Please select a different cell (0-8)"
    PLAY_AGAIN = "Would you like to play again?"
    LOSS = " Game over, you lose!"
    DRAW = " The game ended in a draw"
    AI_TYPE = "Choose an ai type. Type 0 for minimax, 1 for non-minimax"
    BOARD_HEIGHT = "Choose a board size. Type 3 for 3x3, 4 for 4x4"
    FIRST_PLAYER_NAME = "Choose who goes first. Type 0 for AI first, 1 for human first"
    HUMAN_VALUE = "Choose your character. Type X or O"

  def output_message(message_name) 
    puts self.class.const_get(message_name)
  end

  def accept_input
    gets.chomp.downcase
  end

  def draw_board(game_state)
    board = ""
    array_of_cell_values = game_state.convert_cells_to_array
    array_of_cell_values.each_with_index do |value, index|
      insert_values(value, board, index)
      separate_values(board, index)
    end
    puts board
  end

  def insert_values(value, board, index)
    value = ' ' if value.nil?
    board << value
  end

  def separate_values(board, index)
    if (index + 1) % 3 != 0
      board << "|"
    else
      board << "\n"
    end 
  end

end
