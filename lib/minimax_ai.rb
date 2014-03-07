require_relative '../lib/player'
require_relative '../lib/game_state'

class MinimaxAi

  def generate(ai_player, human_player, first_player, height)
    cells = []
    number_of_cells = height ** 2
    number_of_cells.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    initial_game_state = GameState.new(ai_player, human_player, first_player, cells, 1)
  end

  def next_move(game_state)
    if game_state.first_ai_turn? 
      force_first_move(game_state)
    else
      initialize_pruning_values(game_state)
      game_state.get_best_possible_move
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
    if game_state.cell_empty?(4)
      game_state.fill_cell(4)
    else
      game_state.fill_cell(0)
    end
    game_state
  end

  def force_four_by_four_first_move(game_state)
    if game_state.cell_empty?(0)
      game_state.fill_cell(0)
    else
      game_state.fill_cell(15)
    end
    game_state
  end

  def initialize_pruning_values(game_state)
    alpha = -100
    beta = 100
    depth = 0
    generate_moves(game_state, alpha, beta, depth)
  end

  def generate_moves(game_state, alpha, beta, depth)
    game_state.find_empty_cells_to_generate_game_tree(self, alpha, beta, depth)
  end

  def generate_next_game_state(game_state, cell_id, alpha, beta, depth)
    next_game_state = game_state.initialize_next_game_state(cell_id) 
    depth += 1
    game_state.add_next_game_state_to_possible_moves(next_game_state)
    set_alpha_beta(next_game_state, alpha, beta, depth)
  end

  def set_alpha_beta(next_game_state, alpha, beta, depth)
    if next_game_state.final_state?
      next_game_state_rank = next_game_state.rank
      alpha = next_game_state_rank if next_game_state.current_player_is_ai? && next_game_state_rank > alpha
      beta = next_game_state_rank if next_game_state.current_player_is_human? && next_game_state_rank < beta
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
