require 'game_factory'
require 'cell_factory'

describe GameFactory do
  it "builds simple_ai" do
    game_state, ai = described_class.new.build(:ai_type => "simple", :turn => 1, :human_value => "X",
                                               :board_height => 3)
    expect(game_state.class).to eq(GameState)
    expect(ai.class).to eq(SimpleAi)
  end

  it "builds minimax_ai when supplied with cell objects" do
    cells = CellFactory.new(:ai_type => 'minimax').generate_cells(:board_height => 4)
    game_state, ai = described_class.new.build(:ai_type => "minimax", :turn => 1, :human_value => "X",
                                               :cells => cells, :board_height => 4)
    expect(game_state.class).to eq(GameState)
    expect(ai.class).to eq(MinimaxAi)
  end

  it "builds minimax_ai when supplied a board height but no cells" do
    game_state, ai = described_class.new.build(:ai_type => "minimax", :turn => 1, :human_value => "X",
                                               :board_height => 3)
    expect(game_state.class).to eq(GameState)
    expect(ai.class).to eq(MinimaxAi)
  end
end
