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
    params = {:interface => 'command line', :turn => 1}
    params[:ai] = get_ai_type
    params[:board_height] = get_board_height
    params[:first_player_name] = get_first_player_name
    params[:human_value] = get_human_value
    first_turn(params)
  end

  def get_ai_type
    @cli.output_message('AI_TYPE')
    input = @cli.accept_input
    if input == 1
     'non-minimax'
    else
     'minimax'
    end 
  end

  def get_board_height
    @cli.output_message('BOARD_HEIGHT')
    @cli.accept_input.to_i
  end

  def get_first_player_name
    @cli.output_message("FIRST_PLAYER_NAME")
    input = @cli.accept_input
    if input == "0"
      'ai'
    else
      'human'
    end
  end

  def get_human_value
    @cli.output_message("HUMAN_VALUE")
    @cli.accept_input.upcase
  end

  def first_turn(params)
    if params[:first_player_name] == 'ai' 
      ai_move(params)
    else
      human_move(params)
    end
  end

  def ai_move(params)
    params[:cells] = @game_state.cells unless @game_state.nil? 
    next_move = @ttt.command_line_game(params)
    @game_state = next_move unless next_move.nil?
    if @game_state.final_state?
      game_over(params)
    else
      @game_state.human_player_turn
      params[:turn] += 1
      human_move(params)
    end
  end

  def human_move(params)
    @cli.draw_board(@game_state) 
    @cli.output_message("NEXT_MOVE")
    user_input = @cli.accept_input.to_i
    if @game_state.cell_empty?(user_input)
      @game_state = @game_state.initialize_next_game_state(user_input)  
      @game_state.ai_player_turn
      ai_move(params)
    else
      @cli.output_message("INVALID_MOVE")
      human_move(params)
    end
  end

  def game_over(params)      
    winning_cell_results = @game_state.get_winning_cells
    if winning_cell_results
      puts "#{@cli.draw_board(@game_state)} Game over, you lose!"
    elsif @game_state.draw?(winning_cell_results)
      puts "#{@cli.draw_board(@game_state)} The game ended in a draw"
    end
    play_again(params)
  end

  def play_again(params)
    puts "Would you like to play again?"
    response = @cli.accept_input
    unless response == 'n' || response == 'no'
      @game_state = nil
      params[:cells] = nil
      puts "Would you like to change your game options?"
      response = @cli.accept_input
      binding.pry
      if response == 'y' || response == 'yes'
        get_game_options
      else
        first_turn(params)
      end
    else
      abort
    end
  end
end
