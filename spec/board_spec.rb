require 'spec_helper'
require 'board'

describe Board do
  let(:cells) { Cell.generate_default_cells(:board_height => 3) }
  let(:board) { described_class.new(:cells => cells) }

  it "fills cell" do
    board.fill_cell(0, "X")
    expect(board.value_for_cell(0)).to eq("X")
  end

  it "returns size" do
    expect(board.size).to eq(9)
  end

  it "returns height" do
    expect(board.height).to eq(3)
  end

  it "finds empty cells" do
    expect(board.empty_cells).to eq(cells)
  end

  it "doesn't find cells that are filled" do
    board.fill_cell(0, "X")
    expect(board.empty_cells).not_to include(cells[0])
  end

  it "determines that cell is empty" do
    expect(board.cell_empty?(0)).to be_truthy
  end

  it "determines that cell is not empty" do
    board.fill_cell(0, "X")
    expect(board.cell_empty?(0)).to be_falsey
  end

  it "finds corner cells" do
    corner_cells = [cells[0], cells[2], cells[6], cells[8]]
    expect(board.corner_cells).to eq(corner_cells)
  end

  it "finds middle cell" do
    expect(board.middle_cell).to eq (cells[4])
  end

  it "determines if a corner cell has been taken" do
    board.fill_cell(0, "X")
    expect(board.corner_taken?).to be_truthy
  end
end
