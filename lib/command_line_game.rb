require_relative '../lib/command_line_interface'

class CommandLineGame

  def initialize(ai, cli, ttt)
    @ai = ai
    @cli = cli
    @ttt = ttt
  end

  def run
    @cli.output_message('GREETING')
    input = @cli.accept_input
    start_game(input)
  end
  
  def start_game(input)
    unless input == 'n' || input == 'no'
      get_game_options
    else
      @cli.output_message('FAREWELL')
      abort
    end
  end

  def get_game_options
    @params = { :interface => 'command line', :turn => 1 }
    @params[:ai] = @cli.get_ai_type
    @params[:board_height] = @cli.get_board_height
    @params[:first_player_name] = @cli.get_first_player_name
    @params[:human_value] = @cli.get_human_value
    first_turn
  end


  def first_turn
    if @params[:first_player_name] == 'ai' 
      ai_move
    else
      human_move
    end
  end

  def ai_move
    @params[:cells] = @game_state.cells unless @game_state.nil? 
    next_move = @ttt.command_line_game(@params)
    @game_state = next_move unless next_move.nil?
    if @game_state.final_state?
      game_over
    else
      @game_state.human_player_turn
      @params[:turn] += 1
      human_move
    end
  end

  def human_move
    user_input = @cli.start_human_move(@game_state)
    if @game_state.cell_empty?(user_input)
      @game_state = @game_state.initialize_next_game_state(user_input)  
      @game_state.ai_player_turn
      ai_move
    else
      @cli.output_message("INVALID_MOVE")
      human_move
    end
  end

  def game_over      
    winning_cell_results = @game_state.get_winning_cells
    if winning_cell_results
      @cli.player_loss_response(@game_state)
    elsif @game_state.draw?(winning_cell_results)
      @cli.draw_response(@game_state)
    end
    play_again
  end

  def play_again
    response = @cli.play_again_prompt
    unless response == 'n' || response == 'no'
      @game_state = nil
      @params[:cells] = nil
      change_game_options
    else
      abort
    end
  end
    
  def change_game_options
    response = @cli.change_options_prompt
    if response == 'y' || response == 'yes'
      get_game_options
    else
      first_turn
    end
  end

end
