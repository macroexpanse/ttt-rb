require 'spec_helper'
require 'cell'

describe Cell do
  let(:ai) { Ai.new }
  let(:cell) { Cell.new({:id => 5, :position => 'b3', :value => nil}, 'simple') }

  it 'initializes correctly from data' do
    data = [cell.position, cell.row, cell.column, cell.right_x, cell.left_x, cell.value]
    expect(data).to eq(['b3', 'b', '3', false, false, nil])
  end

  it "fills itself" do
    cell.fill("X")
    expect(cell.value).to eq("X")
  end

  it 'converts to json using the custom method' do
   hash_cell = cell.to_hash
   expect(hash_cell).to eq({:id => 5, :position => 'b3', :value => nil})
  end

  it 'adds win to json when there are winning cells' do
    cell.is_winner
    hash_cell = cell.to_hash
    expect(hash_cell).to eq({:id => 5, :position => 'b3', :value => nil, :win => true })
  end

  it 'initializes without row, column, or diagonal values when ai is minimax' do
    hash_cell = {:id => 0, :position => 'a1', :value => nil}
    cell = Cell.build([hash_cell], 'minimax').first
    expect([cell.row, cell.column, cell.right_x, cell.left_x]).to eq [nil, nil, nil, nil]
  end

end
