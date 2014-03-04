require_relative '../lib/command_line_interface'
require 'pry'

class CommandLineGame
  attr_accessor :ai, :cli, :game_state

  def initialize(ai, game_state)
    @ai = ai
    @cli = CommandLineInterface.new(ai)
    @game_state = game_state    
  end

  def run
    @cli.output_message(@cli.class::GREETING)
    input = @cli.accept_input
    start_game(input)
  end
  
  def start_game(input)
    unless input == 'n' || input == 'no'
      game_loop
    else
      @cli.output_message(@cli.class::FAREWELL)
      abort
    end
  end

  def game_loop
    @game_state.moves = []
    puts @cli.draw_board(@game_state)
    @cli.output_message(@cli.class::NEXT_MOVE)
    user_input = @cli.accept_input.to_i
    if @game_state.cell_empty?(user_input)
      @game_state.current_player.name = 'human'
      @game_state.current_player.value = @game_state.ai_value == 'X' ? 'O' : 'X'
      @game_state = @ai.generate_game_state_for(@game_state, user_input)
      ai_move
    else
      @cli.output_message(@cli.class::INVALID_MOVE)
      game_loop
    end
  end

  def ai_move
    @game_state.current_player.name = 'ai'
    @game_state.current_player.value = @game_state.ai_value
    @game_state = ai.next_move(@game_state)
    @game_state.turn += 1
    if @game_state.final_state?
      puts "#{@cli.draw_board(@game_state)} game over"
    else
      game_loop
    end
  end

end
