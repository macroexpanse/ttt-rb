class Ai

  RIGHT_X_LOCATOR = {
    0 => 2,
    1 => 4,
    2 => 6
  }.freeze

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
    elsif diagonal_danger?(player_cells)
      puts "Diagonal danger"
      cells = resolve_diagonal_danger(cells, player_cells)
    elsif cells[0][:value] == 'X' && cells[8][:value] == 'X'
      cells[5][:value] = 'O'
    end
    return cells
  end

  def row_danger?(player_cells)
    player_cells[0][:row] == player_cells[1][:row]
  end

  def resolve_row_danger(cells, player_cells)
    columns = player_cells.collect { |c| c[:column] }
    [0,1,2].each do |column|
      unless columns.include?(column)
        new_cell_id = column + (player_cells[0][:row] * 3)
        cells[new_cell_id][:value] = 'O'
        break
      end
    end
    return cells
  end

  def column_danger?(player_cells)
    player_cells[0][:column] == player_cells[1][:column]
  end

  def resolve_column_danger(cells, player_cells)
    rows = player_cells.collect { |c| c[:row] }
    [0,1,2].each do |row|
      unless rows.include?(row)
        new_cell_id = player_cells[0][:column] + (row * 3)
        cells[new_cell_id][:value] = 'O'
        break
      end
    end
    return cells
  end

  def diagonal_danger?(player_cells)
    puts player_cells
    !!player_cells[0][:right_x] && !!player_cells[1][:right_x]
  end

  def resolve_diagonal_danger(cells, player_cells)
    right_xs = player_cells.collect { |c| c[:right_x] }
    [0,1,2].each do |right_x|
      unless right_xs.include?(right_x)
        new_cell_id = RIGHT_X_LOCATOR[right_x]
        cells[new_cell_id][:value] = 'O'
        puts "Cells: #{cells}"
        break
      end
    end
    return cells
  end

  def get_player_cells(cells)
    player_cells = cells.collect { |c| c if c[:value] == 'X' }
    player_cells.compact
  end

end