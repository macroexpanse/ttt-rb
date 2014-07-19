require 'cell'

describe Cell do
  let(:cell) { Cell.new(:id => 5, :value => nil) }

  it "fills itself" do
    cell.fill("X")
    expect(cell.value).to eq("X")
  end

  it 'converts attributes necessary for web game to hash' do
    hash_cell = cell.to_hash
    expect(hash_cell).to eq({:id => 5, :value => nil})
  end

  it 'adds win to json when there are winning cells' do
    cell.is_winner
    hash_cell = cell.to_hash
    expect(hash_cell).to eq({:id => 5, :value => nil, :win => true })
  end

end
