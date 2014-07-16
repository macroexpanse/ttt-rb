require 'sinatra'
require 'json'
require_relative './lib/web_game'
require_relative './lib/game_factory'
require_relative './lib/cell_factory'

get '/' do
  send_file 'views/ttt.html'
end

get '/make_next_move.json' do
  game_factory = GameFactory.new
  cell_factory = CellFactory.new(params["ai"])
  web_game = WebGame.new(:params => params, :game_factory => game_factory,
                         :cell_factory => cell_factory)
  web_game.run.to_json
end

not_found do
  halt 404, 'Page not found'
end
