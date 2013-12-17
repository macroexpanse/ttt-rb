class Cell

	attr_accessor :id
	attr_accessor :row
	attr_accessor :column
	attr_accessor :right_x
	attr_accessor :left_x
	attr_accessor :value
	attr_accessor :win

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