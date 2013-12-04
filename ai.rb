class Ai

  def first_move(cells)
    if [cells[0][:value],cells[2][:value],cells[6][:value],cells[8][:value]].include?('X')
     cells[4][:value] = 'O'
    else
     cells[0][:value] = 'O'
    end
  end

  def second_move(cells)
    player_cells = get_player_cells(cells)
    if row_danger?(player_cells)
      cells = resolve_row_danger(cells, player_cells)
    elsif column_danger?(player_cells)
      cells = resolve_column_danger(cells, player_cells)
    elsif cells[0][:value] == 'X' && cells[8][:value] == 'X'
      cells[5][:value] = 'O'
    end
    return cells
  end

  def row_danger?(player_cells)
    player_cells[0][:row_id] == player_cells[1][:row_id]
  end

  def resolve_row_danger(cells, player_cells)
    column_ids = player_cells.collect { |c| c[:column_id] }
    [0,1,2].each do |column_id|
      unless column_ids.include?(column_id)
        new_cell_id = column_id + (player_cells[0][:row_id] * 3)
        cells[new_cell_id][:value] = 'O'
        break
      end
    end
    return cells
  end

  def column_danger?(player_cells)
    player_cells[0][:column_id] == player_cells[1][:column_id]
  end

  def resolve_column_danger(cells, player_cells)
    row_ids = player_cells.collect { |c| c[:row_id] }
    [0,1,2].each do |row_id|
      unless row_ids.include?(row_id)
        new_cell_id = player_cells[0][:column_id] + (row_id * 3)
        cells[new_cell_id][:value] = 'O'
        break
      end
    end
    return cells
  end

  def get_player_cells(cells)
    player_cells = cells.collect { |c| c if c[:value] == 'X'}
    player_cells.compact
  end

end