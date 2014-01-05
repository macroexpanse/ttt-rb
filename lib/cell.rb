class Cell

	attr_accessor :id, :row, :column, :left_x, :right_x, :value, :win

	def initialize(data)
		self.id = data.fetch('id')
		self.value = data.fetch('value')
		self.row = data.fetch('id').slice(0)
		self.column = data.fetch('id').slice(1)
		self.left_x = true if ['a1', 'b2', 'c3'].include?(self.id)
		self.right_x = true if ['a3', 'b2', 'c1'].include?(self.id)
	end

	def left_x
		@left_x || false
	end

	def right_x
		@right_x || false
	end

	def to_json
		json = { 'id' => self.id, 'value' => self.value }
		json['win'] = true if self.win == true
		return json
	end

	def self.parse_json(json)
		cells = json.map do |json_cell|
			cell = Cell.new( JSON.parse(json_cell) )
		end
	end

	DEFAULT_JSON_CELLS = [
		  {'id' => 'a1', 'value' => ''},
		  {'id' => 'a2', 'value' => ''},
		  {'id' => 'a3', 'value' => ''},
		  {'id' => 'b1', 'value' => ''},
		  {'id' => 'b2', 'value' => ''},
		  {'id' => 'b3', 'value' => ''},
		  {'id' => 'c1', 'value' => ''},
		  {'id' => 'c2', 'value' => ''},
		  {'id' => 'c3', 'value' => ''}
		].map { |cell| cell.to_json }

end