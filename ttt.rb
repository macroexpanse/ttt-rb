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
    ai_player = initialize_ai_player(params)
    if params[:move] == '1' && params[:first_player_name] == 'ai'
      cells[0].value = ai_player.value
      new_cells = cells
    else
      game_tree = GameTree.new
      game_state = GameState.new(ai_player, cells)
      game_tree.generate_moves(game_state)
      new_game_state = game_state.next_move
      if new_game_state.nil?
        new_cells = game_state.cells
      else
        new_cells = new_game_state.cells
      end
    end
    new_cells.map { |cell| cell.to_json }
  end
  
  def make_non_minimax_move(params, cells)
    ai = Ai.new
    board = Board.new({:move => params[:move], :human_value => params[:human_value]})
    cells.map { |cell| cell.value = cell.value.to_s }
    new_cells = ai.check_win(board, cells).map { |cell| cell.to_json }
  end

  def initialize_ai_player(params) 
    ai_player = Player.new({:name => 'ai', :value => params[:ai_value]}) 
  end
end

ttt = TTT.new

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  json_cells = params.select { |param| param.include?('cell') }.values
  cells = Cell.parse_json(json_cells)
  new_cells = ttt.make_next_move(params, cells)
  response = { :cells => new_cells }.to_json
end

not_found do
  halt 404, 'Page not found'
end






