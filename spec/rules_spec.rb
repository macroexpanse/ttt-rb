require 'cell_converter'
require 'rules'

describe Rules do
  include CellConverter

  context "3x3" do
    it 'returns winning cell objects' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])

      winning_cells = [cells[0], cells[1], cells[2]]
      rules = Rules.new(:board => double(:cells => cells, :height => 3))
      expect(rules.winning_cells).to eq(winning_cells)
    end

    it "determines game is over when player wins" do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X',
                                              nil, nil, nil,
                                              nil, nil, nil])

      rules = Rules.new(:board => double(:cells => cells, :height => 3))
      expect(rules.game_over?).to be_truthy
    end

    it "determines game is a draw" do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X',
                                              'X', 'O', 'O',
                                              'O', 'X', 'X'])

      rules = Rules.new(:board => double(:cells => cells, :height => 3,
                                         :empty_cells => []))
      expect(rules.draw?).to be_truthy
    end

    it "determines game is over if game is a draw" do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X',
                                              'X', 'O', 'O',
                                              'O', 'X', 'X'])

      rules = Rules.new(:board => double(:cells => cells, :height => 3,
                                         :empty_cells => []))
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
      winning_cells = [cells[0], cells[1],
                       cells[2], cells[3]]
      rules = Rules.new(:board => double(:cells => cells, :height => 4))
      expect(rules.winning_cells).to eq winning_cells
    end
  end
end

