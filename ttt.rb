require 'sinatra'	
require 'json'
require_relative 'ai.rb'
require_relative 'game.rb'

ai = Ai.new

get '/' do
  erb :ttt
end

get '/game.json' do
  content_type :json
  json = params.values[0..8]
  cells = Game.parse_json(json)
  new_cells = ai.route_move(params[:move], cells)
  json_cells = new_cells.map { |cell| cell.to_json }
  response = {:cells => json_cells}.to_json
  return response
end

not_found do
  halt 404, 'Page not found'
end

