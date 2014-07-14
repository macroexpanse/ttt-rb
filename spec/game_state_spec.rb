require 'spec_helper'
require 'game_state'
require 'game_factory'

describe GameState do
  before :each do
    params = {:human_value => "X", :board_height => 3,
              :turn => 1, :ai_type => "minimax"}
    @game_state, ai = GameFactory.new.build(params)
    @board = @game_state.board
  end

  it "duplicates itself with next move" do
    duplicate_game_state = @game_state.duplicate_with_move(0, "X")
    expect(duplicate_game_state.object_id).not_to eq(@game_state.object_id)
    expect(duplicate_game_state.board.object_id).not_to eq(@game_state.board.object_id)
    expect(duplicate_game_state.board.value_for_cell(0)).to eq("X")
  end

  it "fills cell" do
    @game_state.fill_cell(4, "X")
    expect(@board.value_for_cell(4)).to eq("X")
  end

  it "fills human cell" do
    @game_state.fill_human_cell(2)
    expect(@board.value_for_cell(2)).to eq("X")
  end

  it "fills ai cell" do
    @game_state.fill_ai_cell(3)
    expect(@board.value_for_cell(3)).to eq("O")
  end

  it "increments turn" do
    @game_state.increment_turn
    expect(@game_state.turn).to eq(2)
  end

end
