require 'sinatra'
require 'json'

get '/' do
  erb :ttt
end

get '/game.json' do
  content_type :json
  {:foo => :bar}.to_json
end

not_found do
  halt 404, 'Page not found'
end

