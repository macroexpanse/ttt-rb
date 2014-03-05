class Cell

	attr_accessor :id, :position, :row, :column, :left_x, :right_x, :value, :win

	def initialize(data, ai_type)
		self.id = data.fetch(:id)
		self.value = data.fetch(:value)
    if ai_type == 'nonminimax'
      self.position = data.fetch(:position)
		  self.row = position.slice(0)
		  self.column = position.slice(1)
	    self.left_x = %w(a1 b2 c3).include?(position)
	    self.right_x = %w(a3 b2 c1).include?(position)
    end
	end

	def to_hash
		hash = { :id => self.id, :position => self.position, :value => self.value }
		hash[:win] = true if self.win == true
		hash
	end

	def self.build(array_of_hash_cells, ai_type)
		array_of_hash_cells.map { |hash_cell| Cell.new( JSON.parse(hash_cell, :symbolize_names => true), ai_type ) }
	end

end
