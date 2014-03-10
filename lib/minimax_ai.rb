require_relative '../lib/player'
require_relative '../lib/game_state'

class MinimaxAi

  def generate_initial_game_state(ai_player, human_player, first_player, height)
    cells = generate_default_cells(height) 
    GameState.new(ai_player, human_player, first_player, cells, 1)
  end

  def generate_default_cells(height)
    cells = []
    number_of_cells = height ** 2
    number_of_cells.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    cells
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
    depth += 1
    return if depth > game_state.get_board_height || alpha >= beta
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, alpha, beta, depth)
      end
    end
  end

  def generate_next_game_state(game_state, cell_id, alpha, beta, depth)
    next_game_state = game_state.initialize_next_game_state(cell_id) 
    game_state.add_next_game_state_to_possible_moves(next_game_state)
    set_alpha_beta(next_game_state, alpha, beta, depth)
  end

  def set_alpha_beta(next_game_state, alpha, beta, depth)
    if next_game_state.final_state?
      next_game_state_rank = next_game_state.rank
      alpha = next_game_state_rank if next_game_state.current_player_is_ai? && next_game_state_rank > alpha
      beta = next_game_state_rank if next_game_state.current_player_is_human? && next_game_state_rank < beta
    end
    generate_moves(next_game_state, alpha, beta, depth)
  end

end
