require_relative '../ttt.rb'
require_relative '../ai.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

def default_game
  { :cells => [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',]
  }
end

describe 'Tic Tac Toe Service' do
  include Rack::Test::Methods

  it 'loads the home page' do
    get '/'
    last_response.should be_ok
  end

  it 'recieves data from front end' do
    get '/game.json', :rows => default_game

    last_response.should be_ok
  end

  it 'responds to first move if not in corner' do
    game = default_game
    ai = Ai.new
    game[:cells][4] = 'X'
    game = ai.first_move(game)
    game[:cells][0].should == 'O'
  end

  it 'responds to first move if in corner' do
    game = default_game
    ai = Ai.new
    game[:cells][0] = 'X'
    game = ai.first_move(game)
    game[:cells][4].should == 'O'
  end
end
