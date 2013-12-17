require_relative '../ttt.rb'
require_relative '../ai.rb'
require 'rack/test'

set :environment, :test

def app
  Sinatra::Application
end

describe 'Tic Tac Toe Service' do
  include Rack::Test::Methods

  let(:ai) { Ai.new }
  let(:cells) { Game.parse_json(Game.default_cell_data) }

  it 'loads the home page' do
    get '/'
    last_response.should be_ok
  end

  it 'responds to first move if not in corner' do
    cells[4].value = 'X'
    new_cells = ai.place_move_1(cells)
    cells[0].value.should == 'O'
  end

  it 'responds to first move if in corner' do
    cells[0].value = 'X'
    new_cells = ai.place_move_1(cells)
    cells[4].value.should == 'O'
  end

  it 'responds to second move if first and last corner taken' do
    cells[0].value = 'X'
    cells[8].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.place_move_2(cells)
    new_cells[5].value.should == 'O'
  end

  it 'responds to second move if 2 Xs in same row' do
    cells[6].value = 'X'
    cells[8].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.place_move_2(cells)
    new_cells[7].value.should == 'O'
  end

  it 'responds to second move if 2 Xs in same column' do
    cells[2].value = 'X'
    cells[8].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.place_move_2(cells)
    new_cells[5].value.should == 'O'
  end

  it 'responds to second move if 2 Xs associated diagonally' do
    cells[4].value = 'X'
    cells[6].value = 'X'
    cells[0].value = 'O'
    new_cells = ai.place_move_2(cells)
    new_cells[2].value.should == 'O'
  end

  it 'responds to unskilled second move optimally if row opening' do
    cells[0].value = 'X'
    cells[7].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.place_move_2(cells)
    expect([new_cells[3].value, new_cells[5].value]).to include('O')
  end

  it 'responds to third move if 2 Xs in the same row' do
    cells[0].value = 'X'
    cells[3].value = 'X'
    cells[1].value = 'X'
    cells[4].value = 'O'
    cells[6].value = 'O'
    new_cells = ai.place_move_3(cells)
    new_cells[2].value.should == 'O'
  end

  it 'wins with third move if 3 Xs in top corner' do
    cells[0].value = 'X'
    cells[3].value = 'X'
    cells[1].value = 'X'
    cells[4].value = 'O'
    cells[6].value = 'O'
    new_cells = ai.place_move_3(cells)
    new_cells[2].value.should == 'O'
  end

  it 'responds to unskilled third move optimally if right_x opening for win' do
    cells[1].value = 'X'
    cells[2].value = 'X'
    cells[5].value = 'X'
    cells[0].value = 'O'
    cells[4].value = 'O'
    new_cells = ai.place_move_3(cells)
    new_cells[8].value.should == 'O'  
  end

end
