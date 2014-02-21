require 'sinatra'
require 'pry'
require 'json'
require_relative 'lib/game_tree.rb'
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
    if params[:move] == '1' && params[:first_player_name] == 'ai'
      force_first_move(ai_player, cells)
    else
      calculate_minimax_first_move(ai_player, cells)
    end
  end

  def force_first_move(ai_player, cells)
    cells[0].value = ai_player.value
    cells
  end

  def calculate_minimax_first_move(ai_player, cells)
    game_tree = GameTree.new
    game_state = GameState.new(ai_player, cells)
    game_tree.generate_moves(game_state)
    new_game_state = game_state.next_move
    new_game_state.nil? ? game_state.cells : new_game_state.cells
  end
  
  def make_non_minimax_move(params, cells)
    ai = Ai.new
    board = Board.new({:move => params[:move], :human_value => params[:human_value]})
    ai.check_win(board, cells)
  end

end

ttt = TTT.new

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  json_cells = params.select { |param| param.include?('cell') }.values
  cells = Cell.parse_json(json_cells, params[:ai])
  new_cells = ttt.make_next_move(params, cells)
  json_cells = new_cells.map { |cell| cell.to_json }
  response = { :cells => json_cells }.to_json
end

not_found do
  halt 404, 'Page not found'
end






