require_relative '../lib/cell'

def convert_array_to_minimax_cells(array)
  cells = []
  array.each_with_index do |value, index|
    cells << Cell.new({:id => index, :value => value}, 'minimax')
  end
  cells
end

def convert_array_to_regular_cells(array)
  cells = []
  array.each_with_index do |value, index|
    rows = 'abc'
    row = rows[index / 3]
    column = index % 3 + 1
    cells << Cell.new({:id => index, :position => row + column.to_s, :value => value}, 'nonminimax')
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
