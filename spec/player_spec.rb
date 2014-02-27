require 'spec_helper'
require 'player'

describe 'Player Service' do 
  let(:player) { Player.new({:name => 'human', :value => 'X'})}

  it 'initializes player with name and value' do
    expect([player.name, player.value]).to eq ['human', 'X']
  end

  it 'determines opposite value' do
    expect(player.opposite_value).to eq 'O'
  end

  it 'determines opposite name' do 
    expect(player.opposite_name).to eq 'ai'
  end
end
