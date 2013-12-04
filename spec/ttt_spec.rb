require_relative '../ttt.rb'
require_relative '../ai.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

def default_cells
  [
    {:id => 0, :row_id => 0, :position => 0, :value => ''},
    {:id => 1, :row_id => 0, :position => 1, :value => ''},
    {:id => 2, :row_id => 0, :position => 2, :value => ''},
    {:id => 3, :row_id => 1, :position => 0, :value => ''},
    {:id => 4, :row_id => 1, :position => 1, :value => ''},
    {:id => 5, :row_id => 1, :position => 2, :value => ''},
    {:id => 6, :row_id => 2, :position => 0, :value => ''},
    {:id => 7, :row_id => 2, :position => 1, :value => ''},
    {:id => 8, :row_id => 2, :position => 2, :value => ''}
  ]
end

describe 'Tic Tac Toe Service' do
  include Rack::Test::Methods

  let(:ai) { Ai.new }
  let(:cells) { default_cells.clone }

  it 'loads the home page' do
    get '/'
    last_response.should be_ok
  end

  it 'recieves data from front end' do
    get '/game.json', :cells => cells

    last_response.should be_ok
  end

  it 'responds to first move if not in corner' do
    cells[4][:value] = 'X'
    new_cells = ai.first_move(cells)
    cells[0][:value].should == 'O'
  end

  it 'responds to first move if in corner' do
    cells[0][:value] = 'X'
    new_cells = ai.first_move(cells)
    cells[4][:value].should == 'O'
  end

  it 'responds to second move if first and last corner taken' do
    cells[0][:value] = 'X'
    cells[8][:value] = 'X'
    cells[4][:value] = 'O'
    new_cells = ai.second_move(cells)
    new_cells[5][:value].should == 'O'
  end

  it 'responds to second move if 2 Xs in same row' do
    cells[6][:value] = 'X'
    cells[8][:value] = 'X'
    cells[4][:value] = 'O'
    new_cells = ai.second_move(cells)
    new_cells[7][:value].should == 'O'
  end

end
