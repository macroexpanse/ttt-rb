require_relative '../lib/player.rb'
require 'benchmark'

class GameTree

  def generate(first_player_value)
    cells = []
    9.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    first_player = Player.new({:name => 'ai', :value => first_player_value})
    initial_game_state = GameState.new(first_player, cells, 1) 
  end

  def generate_moves(game_state, alpha, beta)
    if game_state.move == 1
      game_state.moves << force_first_move(game_state) 
      game_state.rank = 0
      return
    end
    return if alpha >= beta
    next_player = Player.new({:name => game_state.current_player.opposite_name, :value => game_state.current_player.opposite_value})
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, next_player, alpha, beta)
      end
    end
  end

  def force_first_move(game_state)
    game_state.cells[4].value.nil? ? game_state.cells[4].value = game_state.ai_value : game_state.cells[0].value = game_state.ai_value
    game_state
  end
  
  def generate_next_game_state(game_state, cell_id, next_player, alpha, beta)
    next_cells = game_state.cells.collect { |cell| cell.dup }
    next_cells[cell_id].value = game_state.current_player.value
    next_game_state = GameState.new(next_player, next_cells, (game_state.move + 1))
    game_state.moves << next_game_state
    if game_state.final_state? 
      next_game_state_rank = next_game_state.rank
      if next_player.name == 'ai' && next_game_state_rank > alpha
        alpha = next_game_state_rank
      elsif next_player.name == 'human' && next_game_state_rank < beta 
        beta = next_game_state_rank
      end
    end
    generate_moves(next_game_state, alpha, beta)
  end

end

