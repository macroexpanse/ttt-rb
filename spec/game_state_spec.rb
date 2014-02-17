require_relative '../ttt.rb'
require_relative '../lib/game_state.rb'
require_relative '../lib/cell.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Game State Service' do
  let(:game_state) { GameState.new }
  let(:cells) { Cell.create_default_cells }
  let(:board) { Board.new('human_value' => 'O') }

  it "initializes with current_player and cells" do
   game_state = GameState.new(board.human_value, cells)
   expect(game_state.moves).to eq []
  end

end

