require 'spec_helper'
require_relative '../lib/ttt'

describe 'TTT Service' do 
  let(:ttt) { TTT.new }
  let(:minimax_ai) { MinimaxAi.new }
  let(:ai_player) { Player.new({:name => 'ai', :value => 'X', :current_player => true}) }
  let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
  let(:game_state) { minimax_ai.generate(ai_player, human_player, ai_player, 3) }


  it 'follows minimax path' do
    params = {:ai => 'minimax', :first_player_name => 'human', :turn => 1, :human_value => 'X', :ai_value => 'O'}
    cells = convert_array_to_minimax_cells(['O', nil, nil, 
                                            nil, 'O', nil, 
                                            'X', nil, nil])
    new_game_state = ttt.start_turn(params, cells)
    next_cells = new_game_state.serve_cells_to_front_end    
    expect(next_cells[0].value).to eq 'O'
  end

  it 'follows non-minimax path' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                             nil, 'X', nil, 
                                             nil, nil, nil])
    params = {:ai => 'nonminimax', :turn => '1', :human_value => 'X', :ai_value => 'O'}
    next_cells = ttt.start_turn(params, cells)
    expect(next_cells[0].value).to eq 'O' 
  end

  it 'moves in middle cell on first move when ai is first player' do
    params = {:ai => 'minimax', :turn => 1, :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_game_state = ttt.start_turn(params, game_state.serve_cells_to_front_end)
    new_cells = new_game_state.serve_cells_to_front_end
    expect(new_cells[4].value).to eq 'O'
  end

  it 'blocks row correctly when minimax ai goes first' do
    cells = convert_array_to_minimax_cells(['X', 'X', 'O', 
                                                       nil, 'O', nil, 
                                                       nil, nil, nil])
    params = { :ai => 'minimax', :turn => 3, :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_game_state = ttt.start_turn(params, cells)
    next_cells = new_game_state.serve_cells_to_front_end    
    expect(next_cells[6].value).to eq 'O'
  end
end
