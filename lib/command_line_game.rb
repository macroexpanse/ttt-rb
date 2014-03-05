require_relative '../lib/command_line_interface'

class CommandLineGame

  def initialize(ai, game_state, cli)
    @ai = ai
    @cli = cli
    @game_state = game_state    
  end

  def run
    @cli.output_message('GREETING')
    input = @cli.accept_input
    start_game(input)
  end
  
  def start_game(input)
    unless input == 'n' || input == 'no'
      human_move
    else
      @cli.output_message('FAREWELL')
      abort
    end
  end

  def human_move
    @game_state.moves = []
    @cli.draw_board(@game_state) 
    @cli.output_message("NEXT_MOVE")
    user_input = @cli.accept_input.to_i
    if @game_state.cell_empty?(user_input)
      @game_state.current_player.name = 'human'
      @game_state.current_player.value = @game_state.ai_value == 'X' ? 'O' : 'X'
      @game_state.fill_cell_based_on_user_input(user_input)
      # should check here if game is over
      ai_move
    else
      @cli.output_message("INVALID_MOVE")
      human_move
    end
  end

  def ai_move
    @game_state.current_player.name = 'ai'
    @game_state.current_player.value = @game_state.ai_value
    next_move = @ai.next_move(@game_state)
    @game_state = next_move unless next_move.nil?
    if @game_state.final_state?
      game_over
      new_game
    else
      @game_state.turn += 1
      human_move
    end
  end

  def game_over      
    winning_cell_results = @game_state.get_winning_cells
    if winning_cell_results
      puts "#{@cli.draw_board(@game_state)} Game over, you lose!"
    elsif @game_state.draw?(winning_cell_results)
      puts "#{@cli.draw_board(@game_state)} The game ended in a draw"
    end
  end
  
  def new_game 
    @cli.output_message("PLAY_AGAIN")
    user_input = @cli.accept_input
    unless user_input == 'n' || user_input == 'no'
      @game_state = @ai.generate('O', 'human', 3)
      human_move
    else
      @cli.output_message("FAREWELL")
    end
  end

end
