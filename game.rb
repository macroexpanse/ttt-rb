require_relative 'cell.rb'

class Game

	def self.default_cell_data
		data = [
		  {'id' => 0, 'row' => 0, 'column' => 0, 'right_x' => false, 'left_x' => true, 'value' => ''},
		  {'id' => 1, 'row' => 0, 'column' => 1, 'right_x' => false, 'left_x' => false, 'value' => ''},
		  {'id' => 2, 'row' => 0, 'column' => 2, 'right_x' => true, 'left_x' => false, 'value' => ''},
		  {'id' => 3, 'row' => 1, 'column' => 0, 'right_x' => false, 'left_x' => false, 'value' => ''},
		  {'id' => 4, 'row' => 1, 'column' => 1, 'right_x' => true, 'left_x' => true, 'value' => ''},
		  {'id' => 5, 'row' => 1, 'column' => 2, 'right_x' => false, 'left_x' => false, 'value' => ''},
		  {'id' => 6, 'row' => 2, 'column' => 0, 'right_x' => true, 'left_x' => false, 'value' => ''},
		  {'id' => 7, 'row' => 2, 'column' => 1, 'right_x' => false, 'left_x' => false, 'value' => ''},
		  {'id' => 8, 'row' => 2, 'column' => 2, 'right_x' => false, 'left_x' => true, 'value' => ''}
		].map { |cell| cell.to_json }
	end

	def self.parse_json(json)
		cells = json.map do |json_cell|
			cell = Cell.new( JSON.parse(json_cell) )
		end
	end

	def self.corner_taken?(cells)
		[cells[0].value,cells[2].value,cells[6].value,cells[8].value].include?('X')
	end

	def self.opposite_corners_taken?(cells)
		cells[0].value + cells[8].value == 'XX' || cells[2].value + cells[6].value == 'XX'
	end

	def self.corner_and_middle_taken?(cells)
		self.corner_taken?(cells) && cells[4].value == 'X'
	end

	def self.select_player_cells(cells, player_value)
	  player_cells = cells.select { |c| c.value == player_value }
	end

	def self.select_duplicate_cells(player_cells, type)
		associations = player_cells.collect { |c| c.send(type) }
		unique_duplicate = associations.select { |association| associations.count(association) > 1 }.uniq
		unique_duplicate = [nil] if unique_duplicate.include?(false)
		return unique_duplicate
	end
	
end