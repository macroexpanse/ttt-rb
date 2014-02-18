class GameTree

  def generate(first_player_value)
    cells = []
    9.times do |index|
      cells << Cell.new({:id => index, :value => nil})
    end
    initial_game_state = GameState.new(first_player_value, cells) 
  end

  def generate_moves(game_state)
    next_player = (game_state.current_player == 'X' ? 'O' : 'X')
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, next_player)
      end
    end
  end
  
  def generate_next_game_state(game_state, cell_id, next_player)
    next_cells = game_state.cells.collect { |cell| cell.dup }
    next_cells[cell_id].value = game_state.current_player
    next_game_state = GameState.new(next_player, next_cells)
    game_state.moves << next_game_state
    generate_moves(next_game_state)
  end

end

