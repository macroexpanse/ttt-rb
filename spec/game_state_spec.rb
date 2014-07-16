require 'spec_helper'
require 'game_factory'

describe GameState do
  let(:game_state) { @game_state }
  let(:board) { @board }

  before :each do
    params = {:human_value => "X", :board_height => 3,
              :turn => 1, :ai_type => "minimax"}
    @game_state, _ = GameFactory.new.build(params)
    @board = game_state.board
  end

  it "fills cell" do
    game_state.fill_cell(4, "X")
    expect(board.value_for_cell(4)).to eq("X")
  end

  it "fills human cell" do
    game_state.fill_human_cell(2)
    expect(board.value_for_cell(2)).to eq("X")
  end

  it "fills ai cell" do
    game_state.fill_ai_cell(3)
    expect(board.value_for_cell(3)).to eq("O")
  end

  it "increments turn" do
    game_state.increment_turn
    expect(game_state.turn).to eq(2)
  end

  it "ensures turn is converted to an integer" do
    params = {:human_value => "X", :board_height => 3,
              :turn => "1", :ai_type => "minimax"}
    game_state, ai = GameFactory.new.build(params)
    expect(game_state.turn).to eq(1)
  end

end
