class CommandLineGame

  def initialize(ai, cli, ttt, ai_player, human_player)
    @ai = ai
    @cli = cli
    @ttt = ttt
    @ai_player = ai_player
    @human_player = human_player
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
    initialize_default_game_state if @game_state.nil?
    if @params["first_player_name"] == 'ai'
      ai_move
    else
      human_move
    end
  end

  def initialize_default_game_state
    @human_player.value = @params["human_value"]
    @ai_player.value = @human_player.opposite_value
    first_player = @params["first_player_name"] == 'ai' ? @ai_player : @human_player
    cells = Cell.generate_default_cells(@params["board_height"])
    @game_state = GameState.new(@ai_player, @human_player, first_player, cells, 1)
  end

  def ai_move
    next_move = @ttt.start_turn(@params, @game_state.cells)
    @game_state = next_move unless next_move.nil?
    winning_cells = @ai.get_winning_cells(@game_state)
    if @game_state.final_state?(winning_cells)
      game_over
    else
      @game_state.human_player_turn
      @params["turn"] += 1
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
    winning_cells = @ai.get_winning_cells(@game_state)
    if winning_cells
      @cli.player_loss_response(@game_state)
    elsif @game_state.draw?(winning_cells)
      @cli.draw_response(@game_state)
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


