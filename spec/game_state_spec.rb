require 'player'
require 'cell'
require 'game_state'
require 'board'
require 'spec_helper'

describe GameState do
  let(:ai_player) { Player.new({:name => 'ai', :value => 'X'})}
  let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
  let(:cells) { Cell.generate_default_cells(3) }
  let(:board) { Board.new(:cells => cells)}
  let(:win_conditions) { WinConditions.new(3) }
  let(:rules) { Rules.new(:win_conditions => win_conditions)}
  let(:game_state) { GameState.new(:ai_player => ai_player, :human_player => human_player,
                                   :board => board, :rules => rules, :turn => 2) }

  context '3x3 board' do
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
        game_state.fill_cell(0, game_state.human_player.value)
        array_cells = game_state.convert_cells_to_array

        expect(array_cells).to eq ['O', nil, nil,
                                   nil, nil, nil,
                                   nil, nil, nil]
      end
    end
  end

  context "4x4 board" do
    let(:cells) { Cell.generate_default_cells(4) }
    let(:board) { Board.new(:cells => cells)}
    let(:win_conditions) { WinConditions.new(3) }
    let(:rules) { Rules.new(:win_conditions => win_conditions)}
    let(:game_state) { GameState.new(:ai_player => ai_player, :human_player => human_player,
                                     :board => board, :rules => rules, :turn => 1) }

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

