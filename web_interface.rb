require 'sinatra'
require 'json'
require 'pry'
require_relative './lib/ttt'
require_relative './lib/player'
require_relative './lib/minimax_ai'
require_relative './lib/ai'

minimax_ai = MinimaxAi.new
ai = Ai.new
ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
ttt = TTT.new({:minimax_ai => minimax_ai, :ai => ai, :ai_player => ai_player, :human_player => human_player}) 

get '/' do
  send_file 'views/ttt.html'
end
 
get '/make_next_move.json' do
  ttt.sinatra_game(params).to_json
end

not_found do
  halt 404, 'Page not found'
end






