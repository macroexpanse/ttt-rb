require_relative '../ttt.rb'
require_relative '../lib/game_state.rb'
require_relative '../lib/game_tree.rb'
require_relative '../lib/cell.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Game State Service' do
  let(:cells) { Cell.create_default_cells }
  let(:board) { Board.new('human_value' => 'X') }
  let(:game_tree) { GameTree.new }
  let(:initial_game_state) { game_tree.generate(board.human_value) }

  it "initializes with no moves" do
   expect(initial_game_state.moves).to eq []
  end

  it 'calculates rank for initial game state' do
    game_tree.generate_moves(initial_game_state) 
    expect(initial_game_state.moves.first.rank).to eq 0
  end
end

