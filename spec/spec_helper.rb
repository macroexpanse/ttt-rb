require_relative '../lib/cell.rb'
require 'rack/test'

def app
  Sinatra::Application
end

def convert_string_to_minimax_cells(string)
  string.gsub!("\n", '')
  values = string.split(', ')
  cells = []
  values.each_with_index do |value, index|
    value.strip!
    value == 'nil' ? value = nil : value
    cells << Cell.new({:id => index, :value => value}, 'minimax')
  end
  cells
end

def convert_string_to_regular_cells(string)
  string.gsub!("\n", '')
  values = string.split(', ')
  cells = []
  values.each_with_index do |value, index|
    value.strip!
    value == 'nil' ? value = nil : value
    rows = 'abc'
    row = rows[index / 3]
    column = index % 3 + 1
    cells << Cell.new({:id => index, :position => row + column.to_s, :value => value}, 'nonminimax')
  end
  cells
end

def convert_cells_to_string(cells)
  string = ""
  cells.each_with_index do |cell, index|
    value = cell.value
    value == nil ? value = 'nil' : value
    value += ', ' unless index == 8
    string << value
  end
  string
end


