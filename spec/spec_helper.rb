require_relative '../lib/cell.rb'

class Cell

	def self.create_default_cells
		default_cells = []
		9.times do |index|
			rows = 'abc'
	  	row = rows[index / 3]
	  	column = index % 3 + 1
	  	cell = Cell.new({:id => index, :position => row + column.to_s, :value => nil}, 'nonminimax')
	  	default_cells << cell
	  end
	  default_cells
	end

end

def app
  Sinatra::Application
end

def convert_minimax_board(string)
  values = string.split(', ')
  cells = []
  values.each_with_index do |value, index|
    value == 'nil' ? value = nil : value
    cells << Cell.new({:id => index, :value => value}, 'minimax')
  end
  cells
end

def convert_regular_board(string)
  values = string.split(',')
  cells = []
  values.each_with_index do |value, index|
    rows = 'abc'
    row = rows[index / 3]
    column = index % 3 + 1
    cells << Cell.new({:id => index, position => row + column.to_s, :value => value}, 'nonminimax')
  end
end


