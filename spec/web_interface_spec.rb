require 'spec_helper'
require_relative '../web_interface.rb'

describe 'Web Interface Service' do
  include Rack::Test::Methods
  
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
    expect(parsed_response.class).to eq Array 
  end

end


