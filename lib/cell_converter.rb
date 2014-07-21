require 'cell'
require 'simple_ai_cell'
require 'json'

module CellConverter

  def convert_array_to_minimax_cells(array)
    cells = []
    array.each_with_index do |value, index|
      cells << Cell.new(:id => index, :value => value)
    end
    cells
  end

  def convert_array_to_simple_cells(array)
    cells = []
    array.each_with_index do |value, index|
      rows = 'abc'
      row = rows[index / 3]
      column = index % 3 + 1
      cells << SimpleAiCell.new(:id => index, :position => row + column.to_s, :value => value)
    end
    cells
  end

  def convert_cells_to_array(cells)
    array = []
    number_of_cells = cells.count
    height = Math.sqrt(number_of_cells)
    cells.each_with_index do |cell, index|
      value = cell.value
      array << value
    end
    array
  end

  def convert_cells_to_params(cells)
    param_cells = {}
    cells.each_with_index do |cell, index|
      param_cells["cell_#{index}"] = JSON.dump(cell.to_hash)
    end
    param_cells
  end
end
