require 'sinatra'
require 'json'
require_relative './lib/web_game'
require_relative './lib/game_factory'

get '/' do
  send_file 'views/ttt.html'
end

get '/make_next_move.json' do
  factory = GameFactory.new
  WebGame.new(params, factory).run.to_json
end

not_found do
  halt 404, 'Page not found'
end
