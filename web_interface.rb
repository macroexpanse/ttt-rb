require 'sinatra'
require 'json'
require_relative './lib/ttt'

ttt = TTT.new

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  ttt.sinatra_game(params).to_json
end

not_found do
  halt 404, 'Page not found'
end






