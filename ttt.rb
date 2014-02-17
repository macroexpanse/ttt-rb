require 'sinatra'
require 'pry'
require 'json'
require_relative 'lib/game_tree.rb'
require_relative 'lib/game_state.rb'
require_relative 'lib/cell.rb'
require_relative 'lib/board.rb'

game_tree = GameTree.new

get '/' do
  send_file 'views/ttt.html'
end

get '/game.json' do
  json_cells = params.values[0..8]
  cells = Cell.parse_json(json_cells)
  board = Board.new({:cells => cells, :human_value => params[:human_value]})
  if params[:move] == 1
    game_state = game_tree.generate
  else
    game_state = GameState.new(board.ai_value, cells)
  end
  game_tree.generate_moves(game_state)
  binding.pry
  new_game_state = game_state.next_move
  json_cells = new_game_state.cells.map { |cell| cell.to_json }
  response = {:cells => json_cells}.to_json
end

not_found do
  halt 404, 'Page not found'
end

