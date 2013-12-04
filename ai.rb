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
    if danger?(player_cells)
      cells = resolve_danger(cells, player_cells)
    elsif cells[0][:value] == 'X' && cells[8][:value] == 'X'
      cells[5][:value] = 'O'
    end
    return cells
  end

  def danger?(player_cells)
    player_cells[0][:row_id] == player_cells[1][:row_id]
  end

  def resolve_danger(cells, player_cells)
    positions = player_cells.collect { |c| c[:position] }
    [0,1,2].each do |position|
      unless positions.include?(position)
        new_cell_id = position + (player_cells[0][:row_id] * 3)
        cells[new_cell_id][:value] = 'O'
      end
    end
    return cells
  end

  def get_player_cells(cells)
    player_cells = cells.collect { |c| c if c[:value] == 'X'}
    player_cells.compact
  end

end