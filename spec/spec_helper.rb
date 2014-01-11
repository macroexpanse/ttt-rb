require_relative '../lib/cell.rb'
require 'spec_helper.rb'

class Cell

	def self.create_default_json_cells
		default_cells = []
		9.times do |index|
			rows = 'abc'
	  	row = rows[index / 3]
	  	column = index % 3 + 1
	  	default_cells.push('id' => row + column.to_s, 'value' => '')
	  end
	  default_json_cells = default_cells.map { |cell| cell.to_json }
	end

end

set :environment, :test

def app
  Sinatra::Application
end