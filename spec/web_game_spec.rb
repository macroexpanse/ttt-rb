require 'web_game'
require 'ai_interface_spec'

describe WebGame do
  include AiInterfaceSpec

  let(:cells) { [double(:id => 0, :value => "", :to_hash => {:id => 0, :value => ""})] }
  let(:cell_factory) { double(:build => cells) }
  let(:params) { {:cell_0 => "{\"id\":0,\"value\":\"\"}"} }
  let(:ai) { double(:next_move => double(:board => double(:cells => cells))) }
  let(:game_factory) { double(:build => [nil, ai]) }

  it "implements ai interface for ai test double" do
    spec_implements_ai_interface(ai)
  end

  before :each do
    web_game = described_class.new(:params => params, :game_factory => game_factory,
                                   :cell_factory => cell_factory)
    @result = web_game.run
  end

  it "builds cells" do
    expect(cell_factory).to have_received(:build)
  end

  it "builds game" do
    expect(game_factory).to have_received(:build).with(params)
  end

  it "gets next move from ai" do
    expect(ai).to have_received(:next_move)
  end

  it "returns new cells" do
   expect(@result).to eq([{:id => 0, :value => ""}])
  end

end
