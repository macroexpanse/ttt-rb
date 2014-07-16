require './lib/cell_factory'
require './lib/cell'

class WebGame
  attr_reader :params, :game_factory, :cell_factory

  def initialize(args)
    @params = args[:params]
    @game_factory = args[:game_factory]
    @cell_factory = args[:cell_factory]
  end

  def run
    params[:cells] = sort_and_build_cells
    _, @ai = game_factory.build(params)
    new_game_state = @ai.next_move
    new_cells = new_game_state.board.cells
    sort_and_tear_down_cells(new_cells)
  end

  private

  def sort_and_build_cells
    cells = params.select { |param| param.to_s.include?('cell') }.values
    parsed_cells = cells.map { |cell| JSON.parse(cell, :symbolize_names => true) }
    cells = build_cells(parsed_cells)
    cells.sort_by! { |cell| cell.id }
  end

  def build_cells(cell_data)
    cell_factory.build(cell_data)
  end

  def sort_and_tear_down_cells(cells)
    hash_cells = cells.map { |cell| cell.to_hash }
    hash_cells.sort_by! { |hash| hash["id"] }
  end
end
