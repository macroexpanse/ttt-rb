require 'spec_helper'
require_relative '../ttt'

describe 'TTT Service' do 
  include Rack::Test::Methods

  let(:ttt) { TTT.new }
  let(:minimax_ai) { MinimaxAi.new }
  let(:game_state) { minimax_ai.generate('X', 'ai', 3) }

  it 'recieves and responds with json' do
    params = {:ai => 'minimax', :first_player_name => 'human', :turn => 1, :human_value => 'X', :ai_value => 'O',
            :cell0 => {:id => 0, :position => 'a1', :value => nil}.to_json,
            :cell1 => {:id => 1, :position => 'a2', :value => nil}.to_json,
            :cell2 => {:id => 2, :position => 'a3', :value => nil}.to_json,
            :cell3 => {:id => 3, :position => 'b1', :value => nil}.to_json,
            :cell4 => {:id => 4, :position => 'b2', :value => nil}.to_json,
            :cell5 => {:id => 5, :position => 'b3', :value => nil}.to_json,
            :cell6 => {:id => 6, :position => 'c1', :value => nil}.to_json,
            :cell7 => {:id => 7, :position => 'c2', :value => nil}.to_json,
            :cell8 => {:id => 8, :position => 'c3', :value => nil}.to_json}

    get '/make_next_move.json', params
    parsed_response = JSON.parse(last_response.body)
    expect(parsed_response.class).to eq Hash
  end

  it 'follows minimax path' do
    params = {:ai => 'minimax', :first_player_name => 'human', :turn => 1, :human_value => 'X', :ai_value => 'O'}
    cells = convert_array_to_minimax_cells(['O', nil, nil, 
                                            nil, 'O', nil, 
                                            'X', nil, nil])
    new_cells = ttt.make_next_move(params, cells)
    expect(new_cells[0].value).to eq 'O'
  end

  it 'follows non-minimax path' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                             nil, 'X', nil, 
                                             nil, nil, nil])
    params = {:ai => 'nonminimax', :turn => '1', :human_value => 'X', :ai_value => 'O'}
    new_cells = ttt.make_next_move(params, cells)
    expect(new_cells[0].value).to eq 'O' 
  end

  it 'moves in middle cell on first move when ai is first player' do
    params = {:ai => 'minimax', :turn => 1, :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_cells = ttt.make_next_move(params, game_state.serve_cells_to_front_end)
    expect(new_cells[4].value).to eq 'O'
  end

  it 'blocks row correctly when minimax ai goes first' do
    cells = convert_array_to_minimax_cells(['X', 'X', 'O', 
                                                       nil, 'O', nil, 
                                                       nil, nil, nil])
    params = { :ai => 'minimax', :turn => 3, :first_player_name => 'ai', :human_value => 'X', :ai_value => 'O' }
    new_cells = ttt.make_next_move(params, cells)
    expect(new_cells[6].value).to eq 'O'
  end
end
