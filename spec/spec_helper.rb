require_relative '../lib/cell.rb'

class Cell

	def self.create_default_cells
		default_cells = []
		9.times do |index|
			rows = 'abc'
	  	row = rows[index / 3]
	  	column = index % 3 + 1
	  	cell = Cell.new({:id => row + column.to_s, :value => ''})
	  	default_cells.push(cell)
	  end
	  default_cells
	end

end

set :environment, :test

def app
  Sinatra::Application
end