require 'command_line_interface'

class CommandLineGame
  attr_accessor :ai, :ui, :game_state

  def initialize(ai, game_state)
    @ai = ai
    @ui = CommandLineInterface.new(ai)
    @game_state = game_state    
  end

  def run
    @ui.output_message(@ui.class::GREETING)
    input = @ui.accept_input
    start_game(input)
  end
  
  def start_game(input)
    if input == 'y'
      game_loop
    else
      @ui.output_message(@ui.class::FAREWELL)
      abort
    end
  end

  def game_loop
    @ui.draw_board(@game_state)
    @ui.output_message(@ui.class::NEXT_MOVE)
    user_input = @ui.accept_input
    if @game_state.cell_empty?(input)
      minimax_ai.generate_game_state_for(user_input)
    else
      @ui.output_message(@ui.class::INVALID_MOVE)
      game_loop
    end
  end

end
