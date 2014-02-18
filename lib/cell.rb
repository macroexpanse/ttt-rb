require 'pry'

class Cell

	attr_accessor :id, :row, :column, :left_x, :right_x, :value, :win

	def initialize(data)
		self.id = data.fetch(:id)
		self.value = data.fetch(:value)
    if data[:id].is_a? String
		  self.row = data.fetch(:id).slice(0)
		  self.column = data.fetch(:id).slice(1)
	    self.left_x = %w(a1 b2 c3).include?(self.id)
	    self.right_x = %w(a3 b2 c1).include?(self.id)
    end
	end

	def to_json
		json = { :id => self.id, :value => self.value }
		json[:win] = true if self.win == true
		json
	end

	def self.parse_json(json)
		json.map { |json_cell| Cell.new(JSON.parse(json_cell, :symbolize_names => true)) }
	end

end
