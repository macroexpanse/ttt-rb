require_relative '../ttt.rb'
require 'rack/test'

set :environment, :test

def app
	Sinatra::Application
end

describe 'Tic Tac Toe Service' do
	include Rack::Test::Methods

	it 'loads the home page' do
		get '/'
		last_response.should be_ok
	end
end
