require 'player'

describe Player do
  it "gets opposite value for X" do
    player = described_class.new(:name => "human", :value => "X")
    expect(player.opposite_value).to eq("O")
  end

  it "gets opposite value for O" do
    player = described_class.new(:name => "ai", :value => "O")
    expect(player.opposite_value).to eq("X")
  end
end
