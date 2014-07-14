class Board
  attr_accessor :cells

  def initialize(args)
    @cells = args[:cells]
  end

  def cell(id)
    cells[id]
  end

  def fill_cell(id, value)
    cell(id).fill(value)
  end

  def value_for_cell(id)
    cell(id).value
  end

  def size
    cells.count
  end

  def height
    Math.sqrt(size).to_i
  end

  def empty_cells
    cells.select { |cell| cell.value.nil? }
  end

  def cell_empty?(id)
    cell(id).value == nil
  end

  def corner_cells
    [cell(height - height),
     cell(height - 1),
     cell(size - height),
     cell(size - 1)]
  end

  def corner_taken?
    corner_cells.detect { |cell| cell.value }
  end

  def middle_cell
    id = (size - 1) / 2
    cell(id)
  end

  def convert_cells_to_array
    array = []
    cells.each do |cell|
      value = cell.value
      array << value
    end
    array
  end
end
