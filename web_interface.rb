require 'sinatra'
require 'json'
require 'pry'
require_relative './lib/ttt'

ttt = TTT.new

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  cells = ttt.sinatra_game(params)
  { :cells => cells }.to_json
end

not_found do
  halt 404, 'Page not found'
end






