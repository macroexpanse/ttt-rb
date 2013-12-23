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

end