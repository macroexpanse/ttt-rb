require_relative '../ttt.rb'
require_relative '../ai.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

default_game =
  { :rows => [
    { :id => '0', :cells => [
      { :id  => '0', :value => ''}, 
      { :id  => '1', :value => ''}, 
      { :id  => '2', :value => ''}
    ]},
    { :id => '1', :cells => [
      { :id  => '3', :value => ''}, 
      { :id  => '4', :value => ''}, 
      { :id  => '5', :value => ''}
    ]},
    { :id => '2', :cells => [
      { :id  => '6', :value => ''}, 
      { :id  => '7', :value => ''}, 
      { :id  => '8', :value => ''}
    ]}
  ]
}

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

  it 'responds to first move if in center' do
    game = default_game
    puts game[:rows][0][:cells][0][:value]
    ai = Ai.new
    game[:rows][1][:cells][1][:value] = 'X'
    game = ai.first_move(game)
    game[:rows][0][:cells][0][:value].should == 'O'
  end
end
