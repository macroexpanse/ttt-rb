require_relative '../ttt.rb'
require_relative '../lib/game_state.rb'
require_relative '../lib/game_tree.rb'
require_relative '../lib/cell.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Game State Service' do
  let(:game_tree) { GameTree.new }
  let(:initial_game_state) { game_tree.generate('X') }

  it "initializes with no moves" do
   expect(initial_game_state.moves).to eq []
  end

  it 'calculates rank for initial game state' do
    game_tree.generate_moves(initial_game_state) 
    expect(initial_game_state.moves.first.rank).to eq 0
  end

  it 'calculates winning rank for win obvious to human' do
    game_state = initial_game_state
    game_state.cells[0].value = 'X'
    game_state.cells[1].value = 'X'
    game_tree.generate_moves(game_state)
    expect(game_state.rank).to eq 1
  end

  it 'calculates losing rank for loss obvious to human' do
    game_state = initial_game_state
    game_state.cells[6].value = 'O'
    game_state.cells[7].value = 'O'
    game_state.current_player = 'O'
    game_tree.generate_moves(game_state)
    expect(game_state.rank).to eq -1
  end

  it 'calculates tie rank for tie obvious to human' do
    game_state = initial_game_state
    game_state.cells[1].value = 'X'
    game_state.cells[4].value = 'X'
    game_state.cells[6].value = 'X'
    game_state.cells[8].value = 'X'
    game_state.cells[2].value = 'O'
    game_state.cells[3].value = 'O'
    game_state.cells[7].value = 'O'
    game_state.cells[0].value = 'O'
    game_tree.generate_moves(game_state)
    expect(game_state.rank).to eq 0
  end

  it 'determines next move based on maximum rank' do
    game_state = initial_game_state
    game_state.cells[0].value, game_state.cells[1].value = 'X' 
    game_tree.generate_moves(game_state)
    next_move = game_state.next_move
    expect(next_move.rank).to eq 1
  end

end

