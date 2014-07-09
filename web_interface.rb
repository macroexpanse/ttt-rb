require 'sinatra'
require 'json'
require_relative './lib/ttt'
require_relative './lib/player'

ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
ttt = TTT.new(ai_player, human_player)

get '/' do
  send_file 'views/ttt.html'
end

get '/make_next_move.json' do
  ttt.web_game(params).to_json
end

not_found do
  halt 404, 'Page not found'
end
