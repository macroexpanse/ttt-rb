require_relative '../lib/game_tree.rb'
require_relative '../lib/game_state.rb'
require_relative '../lib/cell.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Game Tree Service' do
  let(:game_tree) { GameTree.new }
  let(:initial_game_state) { game_tree.generate('X') }

  it "generates game tree and returns initial game state" do
    expect(initial_game_state.class).to eq GameState 
  end

  it "generates moves for initial game state" do
    game_tree.generate_moves(initial_game_state)
    expect(initial_game_state.moves.count).to eq 9 
  end  
end
