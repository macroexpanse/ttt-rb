class CommandLineGame

  def initialize(cli, ai_player, human_player)
    @cli = cli
    @ai_player = ai_player
    @human_player = human_player
    @ttt = TTT.new(@human_player, @ai_player)
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
    @params = { "interface" => 'command line', "turn" => 1 }
    @params["ai"] = @cli.get_ai_type
    @params["board_height"] = @cli.get_board_height
    @params["first_player_name"] = @cli.get_first_player_name
    @params["human_value"] = @cli.get_human_value
    first_turn
  end

  def first_turn
    initialize_default_game_state
    if @params["first_player_name"] == 'ai'
      ai_move
    else
      human_move
    end
  end

  def initialize_default_game_state
    @human_player.value = @params["human_value"]
    @ai_player.value = @human_player.opposite_value
    cells = Cell.generate_default_cells(@params["board_height"])
    @game_state = GameState.new(@ai_player, @human_player, cells, 1)
    @ai = MinimaxAi.new(@game_state)
  end

  def ai_move
    next_move = @ttt.start_turn(@params, @game_state.cells)
    @game_state = next_move unless next_move.nil?
    if @ai.game_over?
      game_over
    else
      @params["turn"] += 1
      human_move
    end
  end

  def human_move
    user_input = @cli.human_move_prompt(@game_state)
    if @game_state.cell_empty?(user_input)
      @game_state.fill_cell(user_input, @human_player.value)
      ai_move
    else
      @cli.output_message("INVALID_MOVE")
      human_move
    end
  end

  def game_over
    if @ai.draw?
     @cli.draw_response(@game_state)
    elsif @ai.game_over?
      @cli.player_loss_response(@game_state)
    end
    play_again
  end

  def play_again
    response = @cli.play_again_prompt
    unless response == 'n' || response == 'no'
      @game_state = nil
      @params["cells"] = nil
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


