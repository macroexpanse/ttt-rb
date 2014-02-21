require 'game_tree.rb'
require 'game_state.rb'
require 'cell.rb'
require 'board.rb'
require 'spec_helper.rb'

describe 'Game Tree Service' do
  let(:game_tree) { GameTree.new }
  let(:game_state) { game_tree.generate('X') }

  it "generates game tree and returns initial game state" do
    expect(game_state.class).to eq GameState 
  end
 
end