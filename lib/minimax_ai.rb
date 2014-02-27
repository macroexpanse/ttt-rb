require_relative '../lib/player'

class MinimaxAi

  def generate(first_player_value, height)
    cells = []
    number_of_cells = height ** 2
    number_of_cells.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    first_player = Player.new({:name => 'ai', :value => first_player_value})
    initial_game_state = GameState.new(first_player, cells, 1) 
  end

  def next_move(game_state)
    if game_state.turn == 1 && game_state.current_player.name == 'ai'
      game_state.moves << force_first_move(game_state)
    else
      initialize_alpha_beta(game_state)
    end
    game_state.moves.max { |a, b| rank(a) <=> rank(b) }
  end

  def force_first_move(game_state)
    if game_state.cells.count == 9
      force_three_by_three_first_move(game_state)
    else
      force_four_by_four_first_move(game_state)
    end
  end

  def force_three_by_three_first_move(game_state)
    if game_state.cells[4].value.nil?
      game_state.cells[4].value = game_state.ai_value
    else
      game_state.cells[0].value = game_state.ai_value
    end
    game_state
  end

  def force_four_by_four_first_move(game_state)
    if game_state.cells[0].value.nil?
      game_state.cells[0].value = game_state.ai_value
    else
      game_state.cells[15].value = game_state.ai_value
    end
    game_state
  end

  def initialize_alpha_beta(game_state)
    alpha = -100
    beta = 100
    generate_moves(game_state, alpha, beta)
  end

  def rank(game_state)
    if game_state.final_state?
      final_state_rank(game_state)
    else
      intermediate_state_rank(game_state) * 0.9
    end
  end

  def intermediate_state_rank(game_state)
    ranks = game_state.moves.collect { |game_state| rank(game_state) }
    if game_state.current_player.name == 'ai'
      ranks.max
    else
      ranks.min
    end
  end

  def final_state_rank(game_state)
    winning_cell_results = game_state.winning_cells
    return 0 if game_state.draw?(winning_cell_results)
    if winning_cell_results.first.value == game_state.ai_value
      winning_cell_results.map { |winning_cell| winning_cell.win = true }
      1
    else
      -1
    end
  end
   
  def generate_moves(game_state, alpha, beta)
    next_player = game_state.current_player.opposite_player
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, next_player, alpha, beta)
      end
    end
  end
  
  def generate_next_game_state(game_state, cell_id, next_player, alpha, beta)
    next_cells = game_state.cells.collect { |cell| cell.dup }
    next_cells[cell_id].value = game_state.current_player.value
    next_game_state = GameState.new(next_player, next_cells, (game_state.turn + 1))
    game_state.moves << next_game_state
    set_alpha_beta(next_game_state, next_player, alpha, beta)
  end

  def set_alpha_beta(next_game_state, next_player, alpha, beta)
    if next_game_state.final_state?
      next_game_state_rank = rank(next_game_state)
      alpha = next_game_state_rank if next_player.name == 'ai' && next_game_state_rank > alpha
      beta = next_game_state_rank if next_player.name == 'human' && next_game_state_rank < beta
    end
    alpha_beta_pruning(next_game_state, alpha, beta)
  end

  def alpha_beta_pruning(game_state, alpha, beta)
    if alpha >= beta
      return
    else
      generate_moves(game_state, alpha, beta) 
    end
  end

end

