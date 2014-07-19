require 'cell_converter'
require 'cell_factory'
require 'player'
require 'board'
require 'rules'

describe Rules do
  include CellConverter

  let(:ai_player) { Player.new(:name => "ai", :value => "X") }
  let(:human_player) { Player.new(:name => "human", :value => "O") }

  context "3x3" do
    let(:cells) { CellFactory.new(:ai_type => 'minimax').generate_cells(:board_height => 3) }
    let(:board) { Board.new(:cells => cells) }

    it 'returns winning cell objects' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])
      board.cells = cells
      winning_cells = [cells[0], cells[1], cells[2]]
      rules = Rules.new(:board => board)
      expect(rules.winning_cells).to eq(winning_cells)
    end

    it "determines game is over when player wins" do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])
      board.cells = cells

      rules = Rules.new(:board => board)
      expect(rules.game_over?).to be_truthy
    end

    it "determines game is a draw" do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X',
                                              'X', 'O', 'O',
                                              'O', 'X', 'X'])
      board.cells = cells
      rules = Rules.new(:board => board)
      expect(rules.draw?).to be_truthy
    end

    it "determines game is over if game is a draw" do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X',
                                              'X', 'O', 'O',
                                              'O', 'X', 'X'])
      board.cells = cells
      rules = Rules.new(:board => board)
      expect(rules.game_over?).to be_truthy
    end

  end

  context "4x4" do
    let(:cells) { CellFactory.new(:ai_type => 'minimax').generate_cells(:board_height => 4) }
    let(:board) { Board.new(:cells => cells) }

    it "returns winning cell objects" do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'X',
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      board.cells = cells
      winning_cells = [cells[0], cells[1],
                       cells[2], cells[3]]
      rules = Rules.new(:board => board)
      expect(rules.winning_cells).to eq winning_cells
    end
  end
end

