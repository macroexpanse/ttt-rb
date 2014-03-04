require_relative '../lib/command_line_interface'
require 'pry'

class CommandLineGame
  attr_accessor :ai, :cli, :game_state

  def initialize(ai, game_state, cli)
    @ai = ai
    @cli = cli
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
    puts "#{@cli.draw_board(@game_state)} #{@cli.class::NEXT_MOVE}"
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
    if @game_state.final_state?
      game_over
      new_game
    else
      @game_state = @ai.next_move(@game_state)
      @game_state.turn += 1
      game_loop
    end
  end

  def game_over      
    winning_cell_results = @game_state.winning_cells
    if winning_cell_results
      puts "#{@cli.draw_board(@game_state)} Game over, you lose!"
    elsif @game_state.draw?(winning_cell_results)
      puts "#{@cli.draw_board(@game_state)} The game ended in a draw"
    end
  end
  
  def new_game 
    puts "Would you like to play again?"
    user_input = @cli.accept_input
    unless user_input == 'n' || user_input == 'no'
      @game_state = @ai.generate('O', 'human', 3)
      game_loop
    else
      @cli.output_message(@cli.class::FAREWELL)
    end
  end


end
