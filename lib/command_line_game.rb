class CommandLineGame
  attr_reader :cli, :game_factory, :game_state, :ai

  def initialize(cli, game_factory)
    @cli = cli
    @game_factory = game_factory
  end

  def run
    cli.output_message('GREETING')
    input = cli.accept_input
    start_game(input)
  end

  def start_game(input)
    unless input == 'n' || input == 'no'
      get_game_options
    else
      cli.output_message('FAREWELL')
      abort
    end
  end

  private

  def get_game_options
    @params = {:interface => 'command line', :turn => 1}
    @params[:ai] = cli.get_ai_type
    @params[:board_height] = cli.get_board_height
    @params[:first_player_name] = cli.get_first_player_name
    @params[:human_value] = cli.get_human_value
    @game_state, @ai = game_factory.build(@params)
    first_turn
  end

  def first_turn
    if @params[:first_player_name] == 'ai'
      ai_turn
    else
      human_turn
    end
  end

  def ai_turn
    if game_over?
      end_game
    else
      ai_move
      human_turn
    end
  end

  def ai_move
    game_state = ai.next_move
    game_state.increment_turn
  end

  def game_state=(game_state)
    game_state = game_state
  end

  def game_over?
    game_state.game_over?
  end

  def end_game
    if draw?
     cli.draw_response(game_state.board)
    else
      cli.player_loss_response(game_state.board)
    end
    play_again
  end

  def draw?
    game_state.draw?
  end

  def human_turn
    if game_over?
      end_game
    else
      human_move
    end
  end

  def human_move
    user_input = cli.human_move_prompt(game_state.board)
    if valid_input?(user_input)
      fill_cell(user_input)
      ai_turn
    else
      cli.output_message("INVALID_MOVE")
      human_move
    end
  end

  def valid_input?(user_input)
    game_state.board.cell_empty?(user_input)
  end

  def fill_cell(user_input)
    game_state.fill_human_cell(user_input)
  end

  def play_again
    response = cli.play_again_prompt
    unless response == 'n' || response == 'no'
      game_state = nil
      @params["cells"] = nil
      change_game_options
    else
      abort
    end
  end

  def change_game_options
    response = cli.change_options_prompt
    if response == 'y' || response == 'yes'
      get_game_options
    else
      new_game
    end
  end

  def new_game
    @game_state, @ai = game_factory.build(@params)
    first_turn
  end
end
