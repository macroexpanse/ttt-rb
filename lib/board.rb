class Board

  attr_accessor :cells, :turn, :human_value, :ai_value

  def initialize(attrs)
    @cells = attrs[:cells]
    @turn = attrs[:turn]
    @human_value = attrs[:human_value]
    @ai_value = @human_value == 'X' ? 'O' : 'X'
  end

  def corner_taken?
    [@cells[0].value, @cells[2].value, @cells[6].value, @cells[8].value].include?(@human_value)
  end

  def get_cell_value(cell_id)
    @cells[cell_id].value
  end

  def human_cell?(cell_id)
    get_cell_value(cell_id) == @human_value
  end

  def fill_cell(cell_id)
   @cells[cell_id].value = @ai_value
  end

  def opposite_corners_taken?
    if @cells[0].value == @human_value && cells[8].value == @human_value
      true
    elsif @cells[2].value == @human_value && cells[6].value == @human_value
      true
    else
      false
    end
  end

  def corner_and_middle_taken?
    corner_taken? && cells[4].value == @human_value
  end

  def select_player_cells(player_value)
    @cells.select { |c| c.value == player_value }
  end

  def select_duplicate_cells(player_cells, type)
    associations = player_cells.collect { |c| c.send(type) }
    associations.select { |association| associations.count(association) > 1 && association != false }.uniq
  end

  def select_adjacent_cells(type, value)
    first_ai_cell = select_player_cells(@ai_value).first
    @cells.select { |cell| cell.send(type) == first_ai_cell.send(type) && cell.send(type) != false && cell.value == value }
  end

  def set_winning_cells(winning_cell, type)
    winning_cells = @cells.select { |cell| cell.send(type) == winning_cell.send(type) }
    winning_cells.map { |cell| cell.win = true }
  end

end
