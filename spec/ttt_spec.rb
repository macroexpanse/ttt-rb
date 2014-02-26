require 'spec_helper.rb'
require_relative '../ttt.rb'

describe 'TTT Service' do 
  let(:ttt) { TTT.new }
  let(:minimax_ai) { MinimaxAi.new }
  let(:game_state) { minimax_ai.generate('X') }

  it 'initializes TTT game' do
    expect(ttt.class).to eq TTT
  end

  it 'follows minimax path' do
    params = {:ai => 'minimax', :first_player_name => 'human', :turn => 1, :human_value => 'X', :ai_value => 'O'}
    game_state.cells = convert_string_to_minimax_cells('O, nil, nil, 
                                                       nil, O, nil, 
                                                        X, nil, nil')
    new_cells = ttt.make_next_move(params, game_state.cells)
    expect(new_cells[0].value).to eq 'O'
  end

  it 'follows non-minimax path' do
    cells = convert_string_to_regular_cells('nil, nil, nil, 
                                             nil, X, nil, 
                                             nil, nil, nil')
    params = {:ai => 'nonminimax', :turn => '1', :human_value => 'X', :ai_value => 'O'}
    new_cells = ttt.make_next_move(params, cells)
    expect(new_cells[0].value).to eq 'O' 
  end

  it 'moves in middle cell on first move when ai is first player' do
    params = {:ai => 'minimax', :turn => 1, :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_cells = ttt.make_next_move(params, game_state.cells)
    expect(new_cells[4].value).to eq 'O'
  end

  it 'blocks row correctly when minimax ai goes first' do
    game_state.cells = convert_string_to_minimax_cells('X, X, O, 
                                                       nil, O, nil, 
                                                       nil, nil, nil')
    params = { :ai => 'minimax', :turn => 3, :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_cells = ttt.make_next_move(params, game_state.cells)
    expect(new_cells[6].value).to eq 'O'
  end
end
