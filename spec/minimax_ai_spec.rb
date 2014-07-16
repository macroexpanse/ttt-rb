require 'spec_helper'
require 'game_factory'

describe MinimaxAi do
  let(:game_factory) { GameFactory.new }
  let(:alpha) { -100 }
  let(:beta) { 100 }
  let(:game_state) { @game_state }
  let(:minimax_ai) { @minimax_ai }
  let(:board) { @board }

  context "3x3 board" do
    before :each do
      params = {:human_value => "O", :board_height => 3, :turn => 1, :ai_type => "minimax"}
      @game_state, @minimax_ai = game_factory.build(params)
      @board = game_state.board
    end

    it 'blocks row' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['O', 'O', nil,
                                              nil, nil, nil,
                                              'X', nil, nil])

      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', 'O', 'X',
                                  nil, nil, nil,
                                  'X', nil, nil]
    end

    it 'wins row' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['X', 'X', nil,
                                              nil, nil, nil,
                                              'O', 'O', nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['X', 'X', 'X',
                                  nil, nil, nil,
                                  'O', 'O', nil]
    end

    it 'blocks column' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['O', nil, nil,
                                              'O', 'X', nil,
                                              nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', nil, nil,
                                  'O', 'X', nil,
                                  'X', nil, nil]
    end

    it 'wins column' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['X', nil, 'O',
                                              'X', nil, 'O',
                                              nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['X', nil, 'O',
                                  'X', nil, 'O',
                                  'X', nil, nil]
    end

    it 'blocks left diagonal' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['O', nil, nil,
                                              nil, 'O', nil,
                                              'X', nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', nil, nil,
                                  nil, 'O', nil,
                                  'X', nil, 'X']
    end

    it 'wins left diagonal' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['X', nil, nil,
                                              nil, 'X', nil,
                                              'O', 'O', nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['X', nil, nil,
                                  nil, 'X', nil,
                                  'O', 'O', 'X']
    end

    it 'blocks right diagonal' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['X', nil, 'O',
                                              nil, 'O', nil,
                                              nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['X', nil, 'O',
                                  nil, 'O', nil,
                                  'X', nil, nil]
    end

    it 'wins right diagonal' do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells(['O', nil, 'X',
                                              'O', 'X', nil,
                                              nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', nil, 'X',
                                  'O', 'X', nil,
                                  'X', nil, nil]
    end

    it "moves in middle if human player starts in corner" do
      cells = convert_array_to_minimax_cells(["O", nil, nil,
                                              nil, nil, nil,
                                              nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array
      expect(string_cells).to eq ['O', nil, nil,
                                  nil, 'X', nil,
                                  nil, nil, nil]
    end

    it "forces human player to play defensively if opposite corners are taken" do
      game_state.increment_turn
      cells = convert_array_to_minimax_cells([nil, nil, "O",
                                              nil, "X", nil,
                                              "O", nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array
      expect(string_cells).to eq [nil, 'X', "O",
                                  nil, 'X', nil,
                                  "O", nil, nil]
    end
  end

  context "4x4 board" do
    before :each do
      params = {:human_value => "O", :board_height => 4, :turn => 1, :ai_type => "minimax"}
      @game_state, @minimax_ai = game_factory.build(params)
      @board = game_state.board
    end

    it 'generates 4x4 board' do
      array_cells = game_state.board.convert_cells_to_array
      expect(array_cells.count).to eq 16
    end

    it 'forces first move to random corner' do
      next_game_state = minimax_ai.next_move
      corner_cells = board.corner_cells
      corner_cell_values = corner_cells.collect { |cell| cell.value }

      expect(corner_cell_values).to include 'X'
    end

    it 'forces first_move to random corner if top corner taken' do
      cells = convert_array_to_minimax_cells(['O', nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      corner_cells = next_game_state.board.corner_cells
      corner_cell_values = corner_cells.collect { |cell| cell.value }

      expect(corner_cell_values).to include 'X'
    end

    it 'blocks row' do
      2.times { game_state.increment_turn }
      cells = convert_array_to_minimax_cells(['O', 'O', 'O', nil,
                                              'X', nil, nil, nil,
                                              'X', nil, nil, nil,
                                              'X', nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', 'O', 'O', 'X',
                                  'X', nil, nil, nil,
                                  'X', nil, nil, nil,
                                  'X', nil, nil, nil]
    end

    it 'blocks column' do
      2.times { game_state.increment_turn }
      cells = convert_array_to_minimax_cells(['O', 'X', 'X', 'X',
                                              'O', nil, nil, nil,
                                              'O', nil, nil, nil,
                                              nil, nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', 'X', 'X', 'X',
                                  'O', nil, nil, nil,
                                  'O', nil, nil, nil,
                                  'X', nil, nil, nil]
    end

    it 'blocks right diagonal' do
      2.times { game_state.increment_turn }
      cells = convert_array_to_minimax_cells(['O', 'X', 'X', 'X',
                                              nil, 'O', nil, nil,
                                              nil, nil, 'O', nil,
                                              nil, nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq ['O', 'X', 'X', 'X',
                                  nil, 'O', nil, nil,
                                  nil, nil, 'O', nil,
                                  nil, nil, nil, 'X']
    end

    it 'blocks left diagonal' do
      2.times { game_state.increment_turn }
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'O',
                                              nil, nil, 'O', nil,
                                              nil, 'O', nil, nil,
                                              nil, nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq (['X', 'X', 'X', 'O',
                                   nil, nil, 'O', nil,
                                   nil, 'O', nil, nil,
                                   'X', nil, nil, nil])
    end

    it 'blocks corner fork' do
      2.times { game_state.increment_turn }
      cells = convert_array_to_minimax_cells([nil, 'O', 'O', nil,
                                              'X', 'X', 'X', 'O',
                                              nil, 'X', nil, 'O',
                                              nil, nil, nil, nil])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq  ['X', 'O', 'O', nil,
                                   'X', 'X', 'X', 'O',
                                   nil, 'X', nil, 'O',
                                   nil, nil, nil, nil]

    end

    it 'blocks right triangle fork' do
      2.times { game_state.increment_turn }
      cells = convert_array_to_minimax_cells(['O', 'X', 'X', 'X',
                                              'O', 'O', 'X', 'X',
                                              nil, 'O', 'O', nil,
                                              nil, nil, nil, 'X'])
      board.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.board.convert_cells_to_array

      expect(string_cells).to eq  ['O', 'X', 'X', 'X',
                                   'O', 'O', 'X', 'X',
                                   nil, 'O', 'O', 'X',
                                   nil, nil, nil, 'X']

    end
  end
end
