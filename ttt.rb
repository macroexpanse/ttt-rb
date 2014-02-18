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
  ai_value = params[:human_value] == 'X' ? 'O' : 'X'
  game_state = GameState.new(ai_value, :ai, cells)
  game_tree.generate_moves(game_state)
  new_game_state = game_state.next_move
  new_cells = new_game_state.cells.map { |cell| cell.to_json } 
  response = { :cells => new_cells }.to_json
end

not_found do
  halt 404, 'Page not found'
end

