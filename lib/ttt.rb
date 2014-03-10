require_relative '../lib/minimax_ai'
require_relative '../lib/ai'
require_relative '../lib/game_state'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/cell'

class TTT

  def sinatra_game(params)
    cells = sort_and_build_cells(params)
    new_game_state = start_turn(params, cells)
    new_cells = new_game_state.cells
    sort_and_tear_down_cells(new_cells)  
  end

  def sort_and_build_cells(params)
    array_of_hash_cells = params.select { |param| param.include?('cell') }.values
    cells = Cell.build(array_of_hash_cells, params[:ai])
    cells.sort_by! { |cell| cell.id }
  end

  def sort_and_tear_down_cells(new_cells)
    hash_cells = new_cells.map { |cell| cell.to_hash }
    hash_cells.sort_by! { |hash| hash[:id] }
  end

  def command_line_game(params)
    minimax_ai = MinimaxAi.new
    cells = minimax_ai.generate_default_cells(params[:board_height])
    start_turn(params, cells) 
  end

  def start_turn(params, cells)
    if params[:ai] == 'minimax'
      setup_minimax_game(params, cells)
    else
      setup_non_minimax_game(params, cells)
    end
  end
  
  def setup_minimax_game(params, cells)
    ai_value = params[:human_value] == 'X' ? 'O' : 'X'
    ai_player = Player.new({:name => 'ai', :value => ai_value, :current_player => true}) 
    human_player = Player.new({:name => 'human', :value => params[:human_value]}) 
    minimax_ai = MinimaxAi.new
    game_state = GameState.new(ai_player, human_player, ai_player, cells, params[:turn].to_i)
    calculate_minimax_first_move(game_state, minimax_ai)
  end

  def calculate_minimax_first_move(game_state, minimax_ai)
    new_game_state = minimax_ai.next_move(game_state)
    game_state = new_game_state unless new_game_state.nil?
    game_state 
  end
  
  def setup_non_minimax_game(params, cells)
    ai = Ai.new
    board = Board.new({:turn => params[:turn], :human_value => params[:human_value]})
    ai.check_win(board, cells)
  end

end


