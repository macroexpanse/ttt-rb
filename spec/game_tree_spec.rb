require 'game_tree.rb'
require 'game_state.rb'
require 'cell.rb'
require 'board.rb'
require 'spec_helper.rb'
require_relative '../ttt.rb'

describe 'Game Tree Service' do
  let(:game_tree) { GameTree.new }
  let(:game_state) { game_tree.generate('X') }

  it "generates game tree and returns initial game state" do
    expect(game_state.class).to eq GameState 
  end

  it "should ensure that game results in a computer win or tie" do
    expect(playout_all_moves(game_tree, game_state).flatten.uniq.all?).to be_true
  end

end
