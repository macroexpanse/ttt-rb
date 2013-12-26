class Cell

	attr_accessor :id, :row, :column, :right_x, :left_x, :value, :win

	def initialize(data)
		data.each do |attr, value|
			value = value.to_i if attr_is_integer?(attr)
			self.send("#{attr}=", value)
		end
	end

	def attr_is_integer?(attr)
		['id', 'row', 'column'].include?(attr)
	end

	def to_json
		json = Hash.new
		self.instance_variables.each do |var|
			attr = var.to_s.delete('@')
			json[attr] = self.send(attr)
		end
		return json
	end

	def self.parse_json(json)
		cells = json.map do |json_cell|
			cell = Cell.new( JSON.parse(json_cell) )
		end
	end

	DEFAULT_JSON_CELLS = [
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