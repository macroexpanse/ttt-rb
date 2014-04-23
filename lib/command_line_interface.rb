require_relative '../spec/spec_helper'

class CommandLineInterface
    GREETING = "Welcome to ttt-rb, are you ready to play?"
    FAREWELL = "Ok, thanks for playing!"
    NEXT_MOVE = "Enter an integer to select which cell you would like to fill next (zero based)"
    INVALID_MOVE = "That cell is already filled. Please select a different cell (zero based)"
    PLAY_AGAIN = "Would you like to play again?"
    LOSS = " Game over, you lose!"
    DRAW = " The game ended in a draw"
    AI_TYPE = "Choose an ai type. Type 0 for minimax, 1 for non-minimax"
    BOARD_HEIGHT = "Choose a board size. Type 3 for 3x3, 4 for 4x4"
    FIRST_PLAYER_NAME = "Choose who goes first. Type 0 for AI first, 1 for human first"
    HUMAN_VALUE = "Choose your character. Type X or O"
    CHANGE_GAME_OPTIONS = "Would you like to change your game options?"

  def output_message(message_name)
    puts self.class.const_get(message_name)
  end

  def accept_input
    gets.chomp.downcase
  end

  def get_ai_type
    output_message('AI_TYPE')
    input = accept_input
    if input == 1
     'non-minimax'
    else
     'minimax'
    end
  end

  def get_board_height
    output_message('BOARD_HEIGHT')
    height = accept_input.to_i
    unless height.between?(3, 4)
      height = 3
    end
    height
  end

  def get_first_player_name
    output_message("FIRST_PLAYER_NAME")
    input = accept_input
    if input == "0"
      'ai'
    else
      'human'
    end
  end

  def get_human_value
    output_message("HUMAN_VALUE")
    input = accept_input.upcase
    unless input == 'X' || input == 'O'
      input = 'X'
    end
    input
  end

  def start_human_move(game_state)
    draw_board(game_state)
    output_message("NEXT_MOVE")
    input = accept_input.to_i
  end

  def draw_board(game_state)
    board = ""
    array_of_cell_values = game_state.convert_cells_to_array
    array_of_cell_values.each_with_index do |value, index|
      insert_values(value, board, index)
      separate_values(board, index, game_state)
    end
    puts board
  end

  def insert_values(value, board, index)
    value = ' ' if value.nil?
    board << value
  end

  def separate_values(board, index, game_state)
    board_height = game_state.get_board_height
    if (index + 1) % board_height != 0
      board << "|"
    else
      board << "\n"
    end
  end

  def player_loss_response(game_state)
    puts "#{draw_board(game_state)} #{LOSS}"
  end

  def draw_response(game_state)
    puts "#{draw_board(game_state)} #{DRAW}"
  end

  def play_again_prompt
    output_message("PLAY_AGAIN")
    accept_input
  end

  def change_options_prompt
    output_message("CHANGE_GAME_OPTIONS")
    accept_input
  end

end
