class Cell
  attr_reader :id, :position, :row, :column, :left_x, :right_x, :value, :win

  def initialize(data, ai_type)
    @id = data.fetch(:id)
    @value = data.fetch(:value)
    if ai_type == 'nonminimax'
      @position = data.fetch(:position)
      @row = position.slice(0)
      @column = position.slice(1)
      @left_x = %w(a1 b2 c3).include?(position)
      @right_x = %w(a3 b2 c1).include?(position)
    end
  end

  def self.generate_default_cells(args)
    cells = []
    number_of_cells = args[:board_height] ** 2
    number_of_cells.times do |index|
      cells << Cell.new({:id => index, :value => nil}, 'minimax')
    end
    cells
  end

  def fill(value)
    @value = value
  end

  def is_winner
    @win = true
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

