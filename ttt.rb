require 'sinatra'
require 'json'
require_relative 'lib/ai.rb'
require_relative 'lib/cell.rb'
require_relative 'lib/board.rb'

ai = Ai.new

get '/' do
  send_file 'views/ttt.html'
end

get '/game.json' do
  json = params.values[0..8]
  cells = Cell.parse_json(json)
  board = Board.new({'move' => params[:move], 'human_value' => params[:human_value]})
  new_cells = ai.check_win(board, cells)
  json_cells = new_cells.map { |cell| cell.to_json }
  response = {:cells => json_cells}.to_json
end

not_found do
  halt 404, 'Page not found'
end

