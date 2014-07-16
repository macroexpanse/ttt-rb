require 'cell'
require 'simple_ai_cell'

class CellFactory

  def generate_cells(args)
    cells = []
    board_height = args[:board_height].to_i
    number_of_cells = board_height ** 2
    number_of_cells.times do |index|
      rows = 'abcd'
      row = rows[index / board_height]
      column = index % board_height + 1
      cells << args[:cell].new(:id => index, :position => row + column.to_s, :value => nil)
    end
    cells
  end

  def build(cell_data, cell)
    cell_data.map { |hash_cell| cell.new(hash_cell) }
  end

end
