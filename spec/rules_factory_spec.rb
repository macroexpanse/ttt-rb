require 'spec_helper'
require './lib/rules_factory'

describe RulesFactory do
  it "builds simple_ai" do
    rules_factory = described_class.new({:ai_type => "simple", :turn => 1, :human_value => "X"})
    rules = rules_factory.build
    expect(rules.first.class).to eq(Board)
    expect(rules.last.class).to eq(Ai)
  end

  it "builds minimax_ai when supplied with cell objects" do
    cells = Cell.generate_default_cells(4)
    rules_factory = described_class.new({:ai_type => "minimax", :turn => 1, :human_value => "X",
                                      :cells => cells})
    rules = rules_factory.build
    expect(rules.first.class).to eq(GameState)
    expect(rules.last.class).to eq(MinimaxAi)
  end

  it "builds minimax_ai when supplied a board height but no cells" do
    rules_factory = described_class.new({:ai_type => "minimax", :turn => 1, :human_value => "X",
                                      :board_height => 3})
    rules = rules_factory.build
    expect(rules.first.class).to eq(GameState)
    expect(rules.last.class).to eq(MinimaxAi)
  end
end
