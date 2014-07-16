require 'spec_helper'
require 'cell_factory'

describe CellFactory do
  let(:cell_factory) { described_class.new }

  it "generates default cells for a 3x3 board" do
    cells = cell_factory.generate_cells(:board_height => 3, :cell => Cell)
    expect(cells.first.class).to eq(Cell)
    expect(cells.count).to eq (9)
  end

  it 'builds simple ai cell' do
    hash_cell = {:id => 0, :position => 'a1', :value => nil}
    cell = CellFactory.new.build([hash_cell], SimpleAiCell).first
    expect(cell.class).to eq(SimpleAiCell)
  end
end
