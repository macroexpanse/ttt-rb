class Board

	attr_accessor :cells, :move, :human_value, :ai_value

	def initialize(attrs)
		attrs.each { |key, value| self.send("#{key}=", value) }
		self.ai_value = human_value == 'X' ? 'O' : 'X'
	end

	def corner_taken?(cells)
		[cells[0].value,cells[2].value,cells[6].value,cells[8].value].include?(human_value)
	end

	def opposite_corners_taken?(cells)
		cells[0].value + cells[8].value == human_value * 2 || cells[2].value + cells[6].value == human_value * 2
	end

	def corner_and_middle_taken?(cells)
		corner_taken?(cells) && cells[4].value == human_value
	end

	def select_player_cells(cells, player_value)
		cells.select { |c| c.value == player_value }
	end

	def select_duplicate_cells(player_cells, type)
		associations = player_cells.collect { |c| c.send(type) }
		associations.select { |association| associations.count(association) > 1 && association != false }.uniq
	end

	def select_adjacent_cells(cells, type, value)
	  first_ai_cell = select_player_cells(cells, ai_value).first
	  cells.select { |cell| cell.send(type) == first_ai_cell.send(type) && cell.send(type) != false && cell.value == value }
	end

end
