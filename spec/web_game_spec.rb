require 'spec_helper'
require 'cell'
require 'json'
require 'web_game'
require 'game_factory'

describe WebGame do
  let(:cells) { Cell.generate_default_cells(:board_height => 3) }
  let(:cell_params) { convert_cells_to_params(cells) }
  let(:factory) { GameFactory.new }

  it "runs minimax ai game" do
    params = {:ai_type => "minimax", :board_height => 3, :human_value => "X",
              :turn => 1}
    params.merge!(cell_params)
    web_game = WebGame.new(params, factory)
    cells[4].fill("O")
    expect(web_game.run).to eq(cells.map { |cell| cell.to_hash } )
  end

  it "runs simple ai game" do
    params = {:ai_type => "simple", :board_height => 3, :human_value => "X",
              :turn => 1}
    params.merge!(cell_params)
    web_game = WebGame.new(params, factory)
    cells[4].fill("O")
    expect(web_game.run).to eq(cells.map { |cell| cell.to_hash} )
  end

  it "runs 4x4 game" do
    params = {:ai_type => "minimax", :board_height => 4, :human_value => "X",
              :turn => 1}
    cells = Cell.generate_default_cells(:board_height => 4)
    cell_params = convert_cells_to_params(cells)
    params.merge!(cell_params)
    web_game = WebGame.new(params, factory)
    cells = web_game.run
    expected_filled_cell_values = [cells[0][:value], cells[3][:value],
                                   cells[12][:value], cells[15][:value]]
    expect(expected_filled_cell_values).to include "O"
  end
end
