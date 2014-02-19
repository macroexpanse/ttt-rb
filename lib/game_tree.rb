class GameTree

  def generate(first_player_value)
    cells = []
    9.times do |index|
      cells << Cell.new({:id => index, :position => '  ', :value => nil})
    end
    initial_game_state = GameState.new(first_player_value, :ai,  cells) 
  end

  def generate_moves(game_state)
    next_player_value = (game_state.current_player_value == 'X' ? 'O' : 'X')
    next_player_title = (game_state.current_player_title == :ai ? :human : :ai)
    game_state.cells.each do |cell|
      if cell.value.nil?
        generate_next_game_state(game_state, cell.id, next_player_value, next_player_title)
      end
    end
  end
  
  def generate_next_game_state(game_state, cell_id, next_player_value, next_player_title)
    next_cells = game_state.cells.collect { |cell| cell.dup }
    next_cells[cell_id].value = game_state.current_player_value
    next_game_state = GameState.new(next_player_value, next_player_title, next_cells)
    game_state.moves << next_game_state
    generate_moves(next_game_state)
  end

end

