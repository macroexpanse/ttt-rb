require 'sinatra'
require 'pry'
require 'json'
require_relative 'lib/minimax_ai.rb'
require_relative 'lib/ai.rb'
require_relative 'lib/game_state.rb'
require_relative 'lib/cell.rb'
require_relative 'lib/board.rb'
require_relative 'lib/player.rb'

class TTT

  def make_next_move(params, cells)
    if params[:ai] == 'minimax'
      make_minimax_move(params, cells)
    else
      make_non_minimax_move(params, cells)
    end
  end
  
  def make_minimax_move(params, cells)
    ai_player = Player.new({:name => 'ai', :value => params[:ai_value]}) 
    calculate_minimax_first_move(ai_player, cells, params[:turn])
  end

  def calculate_minimax_first_move(ai_player, cells, turn)
    minimax_ai = MinimaxAi.new
    game_state = GameState.new(ai_player, cells, turn.to_i)
    new_game_state = minimax_ai.next_move(game_state)
    new_game_state.nil? ? game_state.cells : new_game_state.cells
  end
  
  def make_non_minimax_move(params, cells)
    ai = Ai.new
    board = Board.new({:turn => params[:turn], :human_value => params[:human_value]})
    ai.check_win(board, cells)
  end

end

ttt = TTT.new

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  hash_cells = params.select { |param| param.include?('cell') }.values
  cells = Cell.build(hash_cells, params[:ai])
  new_cells = ttt.make_next_move(params, cells)
  hash_cells = new_cells.map { |cell| cell.to_hash }
  response = { :cells => hash_cells }.to_json
end

not_found do
  halt 404, 'Page not found'
end






