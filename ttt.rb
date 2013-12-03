require 'sinatra'

get '/' do
	'Tic Tac Toe'
end

not_found do
	halt 404, 'Page not found'
end