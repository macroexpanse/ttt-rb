require_relative '../lib/minimax_ai'
require_relative '../lib/ai'
require_relative '../lib/game_state'
require_relative '../lib/board'
require_relative '../lib/player'

class TTT

  def start_turn(params, cells)
    if params[:ai] == 'minimax'
      setup_minimax_game(params, cells)
    else
      make_non_minimax_move(params, cells)
    end
  end
  
  def setup_minimax_game(params, cells)
    ai_player = Player.new({:name => 'ai', :value => params[:ai_value], :current_player => true}) 
    human_player = Player.new({:name => 'human', :value => params[:human_value]}) 
    minimax_ai = MinimaxAi.new
    game_state = GameState.new(ai_player, human_player, ai_player, cells, params[:turn].to_i)
    calculate_minimax_first_move(game_state, minimax_ai)
  end

  def calculate_minimax_first_move(game_state, minimax_ai)
    new_game_state = minimax_ai.next_move(game_state)
    game_state = new_game_state unless new_game_state == nil
    game_state.serve_cells_to_front_end 
  end
  
  def make_non_minimax_move(params, cells)
    ai = Ai.new
    board = Board.new({:turn => params[:turn], :human_value => params[:human_value]})
    ai.check_win(board, cells)
  end

end


