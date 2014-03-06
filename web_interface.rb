require 'sinatra'
require 'pry'
require 'json'
require_relative 'lib/cell'
require_relative 'lib/ttt'

ttt = TTT.new

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  array_of_hash_cells = params.select { |param| param.include?('cell') }.values
  cells = Cell.build(array_of_hash_cells, params[:ai])
  cells.sort_by! { |cell| cell.id }
  new_game_state = ttt.start_turn(params, cells)
  new_cells = new_game_state.serve_cells_to_front_end
  hash_cells = new_cells.map { |cell| cell.to_hash }
  hash_cells.sort_by! { |hash| hash[:id] }
  response = { :cells => hash_cells }.to_json
end

not_found do
  halt 404, 'Page not found'
end






