class Board
	attr_accessor :move, :human_value

	def initialize(attrs)
		attrs.each { |key, value| self.send("#{key}=", value) }
	end

	def corner_taken?(cells)
		[cells[0].value,cells[2].value,cells[6].value,cells[8].value].include?('X')
	end

	def opposite_corners_taken?(cells)
		cells[0].value + cells[8].value == 'XX' || cells[2].value + cells[6].value == 'XX'
	end

	def corner_and_middle_taken?(cells)
		corner_taken?(cells) && cells[4].value == 'X'
	end

	def select_player_cells(cells, player_value)
	  player_cells = cells.select { |c| c.value == player_value }
	end

	def select_duplicate_cells(player_cells, type)
		associations = player_cells.collect { |c| c.send(type) }
		unique_duplicates = associations.select { |association| associations.count(association) > 1 && association != false }.uniq
		return unique_duplicates
	end

	def select_adjacent_cells(cells, type, value)
	  first_ai_cell = select_player_cells(cells, 'O').first
	  adjacent_cells = cells.select { |cell| cell.send(type) == first_ai_cell.send(type) && cell.send(type) != false && cell.value == value }
	end

end