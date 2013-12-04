require 'sinatra'

get '/' do
  erb :ttt
end

get '/game.json' do
    
end

not_found do
  halt 404, 'Page not found'
end

