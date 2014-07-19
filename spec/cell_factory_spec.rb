require 'cell_factory'
require 'simple_ai_cell'
require 'cell'

describe CellFactory do
  it "generates default cells for a 3x3 board" do
    factory = described_class.new(:ai_type => 'minimax')
    cells = factory.generate_cells(:board_height => 3)
    expect(cells.first.class).to eq(Cell)
    expect(cells.count).to eq (9)
  end

  it 'builds simple ai cell' do
    factory = described_class.new(:ai_type => 'simple')
    hash_cell = {:id => 0, :position => 'a1', :value => nil}
    cell = factory.build([hash_cell]).first
    expect(cell.class).to eq(SimpleAiCell)
  end
end
