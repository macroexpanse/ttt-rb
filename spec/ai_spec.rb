require 'player'
require 'ai'
require 'board'
require 'game_state'
require 'spec_helper'

describe Ai do
  let(:human_player) { Player.new(:value => "O", :name => "human")}
  let(:ai_player) { Player.new(:value => "X", :name => "ai")}

  it 'responds to first move if in middle' do
    cells = convert_array_to_simple_cells([nil, nil, nil,
                                            nil, 'O', nil,
                                            nil, nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 1)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', nil, nil,
                                nil, 'O', nil,
                                nil, nil, nil]
  end

  it 'responds to first move if edge' do
    cells = convert_array_to_simple_cells([nil, nil, nil,
                                            nil, nil, nil,
                                            nil,'O', nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 1)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq [nil, nil, nil,
                                nil, 'X', nil,
                                nil, 'O', nil]
  end

  it 'responds to first move if not in middle' do
    cells = convert_array_to_simple_cells(['O', nil, nil,
                                             nil, nil, nil,
                                             nil, nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 1)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', nil, nil,
                                nil, 'X', nil,
                                nil, nil, nil]
  end

  it 'responds to second move if first and last corner taken' do
    cells = convert_array_to_simple_cells(['O', nil, nil,
                                            nil, 'X', nil,
                                            nil, nil, 'O'])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', nil, nil,
                                nil, 'X', 'X',
                                nil, nil, 'O']
  end

  it 'responds to second move if middle and corner taken' do
    cells = convert_array_to_simple_cells(['X', nil, nil,
                                            nil, 'O', nil,
                                            nil, nil, 'O'])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', nil, nil,
                                nil, 'O', nil,
                                'X', nil, 'O']
  end

  it 'responds to second move if first two edges taken' do
    cells = convert_array_to_simple_cells(['X', 'O', nil,
                                            nil, nil, 'O',
                                            nil, nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', 'O', 'X',
                                nil, nil, 'O',
                                nil, nil, nil]
  end

  it 'responds to second move if last two edges taken' do
    cells = convert_array_to_simple_cells(['X', nil, nil,
                                            nil, nil, 'O',
                                            nil, 'O', nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', nil, nil,
                                nil, nil, 'O',
                                nil, 'O', 'X']
  end

  it 'responds to second move if 2 Xs in same row' do
    cells = convert_array_to_simple_cells([nil, nil, nil,
                                            nil, 'X', nil,
                                            'O', nil, 'O'])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq [nil, nil, nil,
                                nil, 'X', nil,
                                'O', 'X', 'O']
  end

  it 'responds to second move if 2 Xs in same column' do
    cells = convert_array_to_simple_cells([nil, nil, 'O',
                                            nil, 'X', nil,
                                            nil, nil, 'O'])

    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq [nil, nil, 'O',
                                nil, 'X', 'X',
                                nil, nil, 'O']
  end

  it 'responds to second move if 2 Xs associated diagonally' do
    cells = convert_array_to_simple_cells(['X', nil, nil,
                                            nil, 'O', nil,
                                            'O', nil, nil])

    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', nil, 'X',
                                nil, 'O', nil,
                                'O', nil, nil]
  end

  it 'responds to second move in top corner and opposite edge optimally by blocking' do
    cells = convert_array_to_simple_cells(['O', nil, nil,
                                            nil, 'X', nil,
                                            'O', 'O', nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', nil, nil,
                                nil, 'X', nil,
                                'O', 'O', 'X']
  end

  it 'responds to second move in bottom corner and opposite edge optimally by blocking' do
    cells = convert_array_to_simple_cells([nil, 'O', nil,
                                            nil, 'X', nil,
                                            nil, nil, 'O'])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 2)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)
    expect(string_cells).to eq ["X",'O', 'X',
                                nil, 'X', nil,
                                nil, nil, 'O']
  end

  it 'responds to third move if 2 Xs in the same row' do
    cells = convert_array_to_simple_cells(['O', 'O', nil,
                                            'O', 'X', nil,
                                            'X', nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 3)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', 'O', 'X',
                                'O', 'X', nil,
                                'X', nil, nil]
  end

  it 'wins with third move if 3 Xs in top corner' do
    cells = convert_array_to_simple_cells(['O', 'O', nil,
                                            'O', 'X', nil,
                                            'X', nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 3)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', 'O', 'X',
                                'O', 'X', nil,
                                'X', nil, nil]
  end

  it 'responds to edge third move optimally if right_x opening for win' do
    cells = convert_array_to_simple_cells(['X', 'O', 'O',
                                             nil, 'X', 'O',
                                             nil, nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 3)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', 'O', 'O',
                                nil, 'X', 'O',
                                nil, nil, 'X']
  end

  it 'responds to fourth move by moving adjacent' do
    cells = convert_array_to_simple_cells(['O', nil, 'O',
                                            'O', 'X', 'X',
                                            'X', nil, 'O'])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 4)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', 'X', 'O',
                                'O', 'X', 'X',
                                'X', nil, 'O']
  end

  it 'responds to right_x danger on fourth move' do
    cells = convert_array_to_simple_cells(['X', 'X', 'O',
                                             'O', 'O', 'X',
                                             nil, nil, nil])
    board = Board.new(:cells => cells)
    game_state = GameState.new(:board => board, :ai_player => ai_player,
                               :human_player => human_player, :turn => 4)
    ai = Ai.new(game_state)
    new_cells = ai.next_move.board.cells
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', 'X', 'O',
                                'O', 'O', 'X',
                                'X', nil, nil]
  end
end
