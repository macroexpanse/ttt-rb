require 'spec_helper'
require 'simple_ai_cell'

describe SimpleAiCell do
  let(:cell) { described_class.new(:id => 5, :position => 'b3', :value => nil)}

  it 'initializes correctly from data' do
    data = [cell.position, cell.row, cell.column, cell.right_x, cell.left_x, cell.value]
    expect(data).to eq(['b3', 'b', '3', false, false, nil])
  end

  it 'converts attributes necessary for web game to hash' do
    hash_cell = cell.to_hash
    expect(hash_cell).to eq({:id => 5, :value => nil, :position => 'b3'})
  end

end
