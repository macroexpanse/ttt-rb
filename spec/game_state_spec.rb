require_relative '../ttt.rb'
require_relative '../lib/game_state.rb'
require_relative '../lib/game_tree.rb'
require_relative '../lib/cell.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Game State Service' do
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

  it 'calculates winning rank for win obvious to human' do
     game_state = game_tree.generate('X')
     game_state.cells[0], game_state.cells[1] = 'X'
     game_tree.generate_moves(game_state)
     expect(game_state.rank).to eq 1
  end

  it 'calculates losing rank for loss obvious to human' do
    game_state = game_tree.generate('X')
    game_state.cells[6], game_state.cells[7] = 'O'
    game_state.current_player = 'O'
    game_tree.generate_moves(game_state)
    expect(game_state.rank).to eq -1
  end

  it 'calculates tie rank for tie obvious to human' do
    game_state = game_tree.generate('X')
    game_state.cells[1], game_state.cells[4], game_state.cells[6], game_state.cells[8] = 'X'
    game_state.cells[2], game_state.cells[3], game_state.cells[7], game_state.cells[0] = 'O'
    game_tree.generate_moves(game_state)
    expect(game_state.rank).to eq 0
  end

end

