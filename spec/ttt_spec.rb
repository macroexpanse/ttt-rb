require 'spec_helper.rb'
require_relative '../ttt.rb'

describe 'TTT Service' do 
  let(:ttt) { TTT.new }
  let(:game_tree) { GameTree.new }

  it 'initializes TTT game' do
    expect(ttt.class).to eq TTT
  end

  it 'follows minimax path' do
    game_state = game_tree.generate('X')
    params = {:ai => 'minimax', :first_player_name => 'human', :human_value => 'X', :ai_value => 'O'}
    game_state.cells[4].value = 'X'
    new_cells = ttt.make_next_move(params, game_state.cells)
    expect(new_cells[0].value).to eq 'O'
  end

  it 'follows non-minimax path' do
    cells = Cell.create_default_cells
    params = {:ai => 'nonminimax', :move => '1', :human_value => 'X', :ai_value => 'O'}
    cells[4].value = 'X'
    new_cells = ttt.make_next_move(params, cells)
    expect(new_cells[0].value).to eq 'O' 
  end

  it 'moves in first cell on first move when ai is first player' do
    cells = Cell.create_default_cells
    params = {:ai => 'minimax', :move => '1', :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_cells = ttt.make_next_move(params, cells)
    expect(new_cells[0].value).to eq 'O'
  end
end
