require 'command_line_interface'

class CommandLineGame
  attr_accessor :ai, :ui, :game_state

  def initialize(ai, game_state)
    @ai = ai
    @ui = CommandLineInterface.new(ai)
    @game_state = game_state    
  end

  def run
    @ui.output_message(CommandLineInterface::GREETING)
    input = @ui.accept_input
    start_game(input)
  end
  
  def start_game(input)
    if input == 'y'
      @ui.draw_board(@game_state)
    else
      @ui.output_message(CommandLineInterface::FAREWELL)
    end
  end


end
