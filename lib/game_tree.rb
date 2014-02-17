class GameTree

  def generate(first_player_value)
    initial_game_state = GameState.new(first_player_value, Array.new(9)) 
  end

  def generate_moves(game_state)
    next_player = (game_state.current_player == 'X' ? 'O' : 'X')
    game_state.cells.each_with_index do |cell, position|
      unless cell
        generate_next_game_state(game_state, position, next_player)
      end
    end
  end
  
  def generate_next_game_state(game_state, position, next_player)
    next_cells = game_state.cells.dup
    next_cells[position] = game_state.current_player
    next_game_state = GameState.new(next_player, next_cells)
    game_state.moves << next_game_state
    generate_moves(next_game_state)
  end

end

