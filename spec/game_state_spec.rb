require_relative '../ttt.rb'
require 'game_state.rb'
require 'minimax_ai.rb'
require 'cell.rb'
require 'board.rb'
require 'spec_helper.rb'

describe 'Game State Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:game_state) { minimax_ai.generate('X') }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  it "initializes with no moves" do
   expect(game_state.moves).to eq []
  end

  it 'calculates winning rank for ai win' do
    game_state.cells = convert_string_to_minimax_cells('X, X, nil, 
                                                       nil, O, nil, 
                                                       O, nil, nil')
    game_state.turn = 3
    minimax_ai.prune(game_state, alpha, beta)

    expect(minimax_ai.rank(game_state)).to eq 0.9
  end

  it 'calculates losing rank for ai loss' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, nil, 
                                                       nil, nil, X, 
                                                       O, O, nil')
    game_state.current_player.name = 'human'
    game_state.current_player.value = 'O'
    game_state.turn = 3
    minimax_ai.prune(game_state, alpha, beta)

    expect(minimax_ai.rank(game_state)).to eq -0.9 
  end

  it 'calculates tie rank for tie' do
    game_state.cells = convert_string_to_minimax_cells('O, X, O, 
                                                        O, X, nil, 
                                                        X, O, X')
    game_state.turn = 3
    minimax_ai.prune(game_state, alpha, beta)

    expect(minimax_ai.rank(game_state)).to eq 0
  end

  it 'determines next move based on maximum rank' do
    game_state.cells = convert_string_to_minimax_cells('X, X, nil, 
                                                        nil, nil, O, 
                                                        O, nil, nil')
    game_state.turn = 3 
    minimax_ai.prune(game_state, alpha, beta)
    next_move = minimax_ai.next_move(game_state)

    expect(minimax_ai.rank(next_move)).to eq 1
  end

  it 'detects winning cells' do
    game_state.cells = convert_string_to_minimax_cells('X, X, X, 
                                                        nil, nil, nil, 
                                                        nil, nil, nil')
    game_state.turn = 4
    boolean = game_state.winning_positions?(game_state.cells, [0, 1, 2]) 

    expect(boolean).to eq true
  end

  it 'returns winning cell objects' do
    game_state.cells = convert_string_to_minimax_cells('X, X, X, 
                                                       nil, nil, nil, 
                                                       nil, nil, nil')
    game_state.turn = 4

    expect(game_state.winning_cells).to eq [game_state.cells[0], game_state.cells[1], game_state.cells[2]]
  end

end

