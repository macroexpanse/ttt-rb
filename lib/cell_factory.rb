require './lib/cell'
require './lib/simple_ai_cell'

class CellFactory

  def initialize(args)
    @cell_type = args[:ai_type] == "simple" ? SimpleAiCell : Cell
  end

  def generate_cells(args)
    cells = []
    board_height = args[:board_height].to_i
    number_of_cells = board_height ** 2
    number_of_cells.times do |index|
      rows = 'abcd'
      row = rows[index / board_height]
      column = index % board_height + 1
      cells << @cell_type.new(:id => index, :position => row + column.to_s, :value => nil)
    end
    cells
  end

  def build(cell_data)
    cell_data.map { |hash_cell| @cell_type.new(hash_cell) }
  end

end
