require 'sinatra'	
require 'json'
require_relative 'ai.rb'

ai = Ai.new

get '/' do
  erb :ttt
end

get '/game.json' do
  content_type :json
  cells = params.values[0..8]
  cells = cells.map { |c| JSON.parse(c) }
  puts "Cells: #{cells}"
  new_cells = ai.which_move(params[:move], cells)
  puts "New cells: #{new_cells}"
  response = {:cells => new_cells}.to_json
  puts "Response #{response}"
  return response
end

not_found do
  halt 404, 'Page not found'
end

