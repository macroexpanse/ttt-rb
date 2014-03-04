require_relative '../lib/player'
require_relative '../lib/game_state'

class MinimaxAi

  def generate(first_player_value, first_player_name, height)
    cells = []
    number_of_cells = height ** 2
    number_of_cells.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    first_player = Player.new({:name => first_player_name, :value => first_player_value})
    initial_game_state = GameState.new(first_player, cells, 1)
  end

  def next_move(game_state)
    if game_state.first_ai_turn? 
      force_first_move(game_state)
    else
      initialize_pruning_values(game_state)
      game_state.get_best_possible_move(self)
    end
  end

  def force_first_move(game_state)
    if game_state.get_board_size == 9
      force_three_by_three_first_move(game_state)
    else
      force_four_by_four_first_move(game_state)
    end
  end

  def force_three_by_three_first_move(game_state)
    if game_state.middle_empty?
      game_state.fill_middle_cell
    else
      game_state.fill_top_left_corner_cell
    end
    game_state
  end

  def force_four_by_four_first_move(game_state)
    if game_state.top_left_corner_empty?
      game_state.fill_top_left_corner_cell
    else
      game_state.fill_bottom_left_corner_cell
    end
    game_state
  end

  def initialize_pruning_values(game_state)
    alpha = -100
    beta = 100
    depth = 0
    generate_moves(game_state, alpha, beta, depth)
  end

  def rank(game_state)
    if game_state.final_state?
      final_state_rank(game_state)
    else
      intermediate_state_rank(game_state) * 0.9
    end
  end

  def intermediate_state_rank(game_state)
    ranks = game_state.collect_ranks_of_possible_moves(self)
    if game_state.current_player_is_ai?
      ranks.max || 0
    else
      ranks.min || 0
    end
  end

  def final_state_rank(game_state)
    winning_cell_results = game_state.get_winning_cells
    return 0 if game_state.draw?(winning_cell_results)
    if game_state.winning_cells_are_ai_cells?(winning_cell_results)
      game_state.set_win_on_winning_cells(winning_cell_results)
      1
    else
      -1
    end
  end

  def generate_moves(game_state, alpha, beta, depth)
    next_player = game_state.current_player.opposite_player
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, next_player, alpha, beta, depth)
      end
    end
  end

  def generate_next_game_state(game_state, cell_id, next_player, alpha, beta, depth)
    next_cells = game_state.duplicate_cells
    game_state.fill_next_cell(cell_id, next_cells)
    game_state.increment_turn
    next_game_state = GameState.new(next_player, next_cells, game_state.turn)
    depth += 1
    game_state.add_next_game_state_to_possible_moves(next_game_state)
    set_alpha_beta(next_game_state, next_player, alpha, beta, depth)
  end

  def set_alpha_beta(next_game_state, next_player, alpha, beta, depth)
    if next_game_state.final_state?
      next_game_state_rank = rank(next_game_state)
      alpha = next_game_state_rank if next_player.is_ai? && next_game_state_rank > alpha
      beta = next_game_state_rank if next_player.is_human? && next_game_state_rank < beta
    end
    depth_pruning(next_game_state, alpha, beta, depth)
  end

  def depth_pruning(next_game_state, alpha, beta, depth)
    if depth > 3
      return
    else
      alpha_beta_pruning(next_game_state, alpha, beta, depth)
    end
  end

  def alpha_beta_pruning(next_game_state, alpha, beta, depth)
    if alpha >= beta
      return
    else
      generate_moves(next_game_state, alpha, beta, depth)
    end
  end

end
