require 'game_state'
require 'minimax_ai'
require 'cell'
require 'board'
require 'player'
require 'spec_helper'

describe 'Game State Service' do
  let(:ai_player) { Player.new({:name => 'ai', :value => 'X'})}
  let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
  let(:cells) { Cell.generate_default_cells(3) }
  let(:game_state) { GameState.new(ai_player, human_player, ai_player, cells, 2) }
  let(:minimax_ai) { MinimaxAi.new(game_state) }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  context '3x3 board' do

    it 'calculates winning rank for ai win' do
      cells = convert_array_to_minimax_cells(['X', 'X', nil,
                                              nil, 'O', nil,
                                              'O', nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move

      expect(minimax_ai.rank_game_state(next_game_state)).to eq 1
    end

    it 'calculates losing rank for ai loss' do
      cells = convert_array_to_minimax_cells(['X', nil, nil,
                                              nil, nil, 'X',
                                             'O', 'O', 'O'])

      game_state.cells = cells
      expect(minimax_ai.rank_game_state(game_state)).to eq -1
    end

    it 'calculates tie rank for tie' do
      cells = convert_array_to_minimax_cells(['O', 'X', 'O',
                                              'O', 'X', nil,
                                              'X', 'O', 'X'])

      game_state.cells = cells
      game_state.turn =  4
      next_game_state = minimax_ai.next_move

      expect(minimax_ai.rank_game_state(next_game_state)).to eq 0
    end

    it 'determines next move based on maximum rank' do
      cells = convert_array_to_minimax_cells(['X', 'X', nil,
                                              nil, nil, 'O',
                                              'O', nil, nil])

      game_state.cells = cells
      next_game_state = minimax_ai.next_move

      expect(minimax_ai.rank_game_state(next_game_state)).to eq 1
    end

    it 'detects winning cells' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                               nil, nil, nil,
                                               nil, nil, nil])
      game_state.cells = cells
      boolean = minimax_ai.winning_combination?(game_state, [0, 1, 2])
      expect(boolean).to eq true
    end

    it 'returns winning cell objects' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])
      game_state.cells = cells
      winning_cells = [cells[0], cells[1],
                       cells[2]]

      expect(minimax_ai.get_winning_cells(game_state)).to eq  winning_cells
    end

    it 'returns correct corner cells' do
      cells = convert_array_to_minimax_cells([nil, nil, nil,
                                              nil, nil, nil,
                                              nil, nil, nil])
      game_state.cells = cells
      corner_cells = game_state.get_corner_cells
      expect(corner_cells).to eq [game_state.cells[0], game_state.cells[2], game_state.cells[6], game_state.cells[8]]
    end

    context "command line game" do
      it 'rejects move if cell is full' do
        cells = convert_array_to_minimax_cells(['X', nil, nil,
                                                nil, nil, nil,
                                                nil, nil, nil])
        game_state.cells = cells
        boolean = game_state.cell_empty?(0)

        expect(boolean).to eq false
      end

      it 'fills cell from user input' do
        game_state.fill_cell(0)
        array_cells = game_state.convert_cells_to_array

        expect(array_cells).to eq ['X', nil, nil,
                                   nil, nil, nil,
                                   nil, nil, nil]
      end
    end
  end

  context "4x4 board" do
    let(:cells) { Cell.generate_default_cells(4) }
    let(:game_state) { GameState.new(ai_player, human_player, ai_player, cells, 1) }
    let(:minimax_ai) { MinimaxAi.new(game_state) }

    it "returns winning cell objects" do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'X',
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      game_state.cells = cells
      winning_cells = [cells[0], cells[1],
                       cells[2], cells[3]]
      expect(minimax_ai.get_winning_cells(game_state)).to eq winning_cells
    end

    it 'returns correct corner cells' do
      cells = convert_array_to_minimax_cells([nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      game_state.cells = cells
      corner_cells = game_state.get_corner_cells
      expect(corner_cells).to eq [game_state.cells[0], game_state.cells[3], game_state.cells[12], game_state.cells[15]]
    end
  end
end

