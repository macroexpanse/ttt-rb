require 'spec_helper'
require 'cell_factory'
require 'player'
require 'board'
require 'win_conditions'
require 'rules'

describe Rules do
  let(:ai_player) { Player.new(:name => "ai", :value => "X") }
  let(:human_player) { Player.new(:name => "human", :value => "O") }

  context "3x3" do
    let(:cells) { CellFactory.new.generate_cells(:board_height => 3, :cell => Cell) }
    let(:board) { Board.new(:cells => cells) }
    let(:win_conditions) { WinConditions.new(:board_height => 3) }
    let(:rules) { Rules.new(:win_conditions => win_conditions) }

    it 'returns winning cell objects' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])
      board.cells = cells
      winning_cells = [cells[0], cells[1], cells[2]]

      expect(rules.get_winning_cells(board)).to eq(winning_cells)
    end

    it "determines game is over when player wins" do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])
      board.cells = cells
      expect(rules.game_over?(board)).to be_truthy
    end

    it "determines game is a draw" do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X',
                                              'X', 'O', 'O',
                                              'O', 'X', 'X'])
      board.cells = cells
      expect(rules.draw?(board)).to be_truthy
    end

    it "determines game is over if game is a draw" do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X',
                                              'X', 'O', 'O',
                                              'O', 'X', 'X'])
      board.cells = cells
      expect(rules.game_over?(board)).to be_truthy
    end

  end

  context "4x4" do
    let(:cells) { CellFactory.new.generate_cells(:board_height => 4, :cell => Cell) }
    let(:board) { Board.new(:cells => cells) }
    let(:win_conditions) { WinConditions.new(:board_height => 4) }
    let(:rules) { Rules.new(:win_conditions => win_conditions) }

    it "returns winning cell objects" do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'X',
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      board.cells = cells
      winning_cells = [cells[0], cells[1],
                       cells[2], cells[3]]
      expect(rules.get_winning_cells(board)).to eq winning_cells
    end
  end
end
