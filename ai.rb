class Ai

  def route_move(move, cells)
    cells = self.send("place_move_#{move}", cells)
  end

  def place_move_1(cells)
    if Game.corner_taken?(cells) && cells[4].value == ''
     cells[4].value = 'O'
    else
     cells[0].value = 'O'
    end
    return cells
  end

  def place_move_2(cells)
    if Game.opposite_corners_taken?(cells)
      cells[5].value = 'O'
      return cells
    else
      cells = place_move_3(cells)
    end
  end

  def place_move_3(cells)
    puts "placing move 3"
    player_cells = Game.select_player_cells(cells, 'X')
    dangerous_cell = check_danger(cells, player_cells)
    if !!dangerous_cell
      puts "Danger!"
      dangerous_cell.value = 'O'
      return cells
    else
      puts "Deciding optimal move..."
      cells = decide_optimal_move(cells, player_cells)
    end
  end

  def place_move_4(cells)
    puts "placing move 4"
    player_cells = Game.select_player_cells(cells, 'X')
    dangerous_cell = check_danger(cells, player_cells)
    if !!dangerous_cell
      puts "Danger!"
      dangerous_cell.value = 'O'
      return cells
    else
      puts "Deciding optimal move..."
      cells = decide_optimal_move(cells, player_cells)
    end
  end

  def check_danger(cells, player_cells)
    ['row', 'column', 'right_x'].each do |type|
      dangerous_cell = get_dangerous_cell(cells, player_cells, type)
      if !!dangerous_cell
        return dangerous_cell
        break
      else
        next
      end
    end
    return nil
  end

  def get_dangerous_cell(cells, player_cells, type)
    duplicate_cells = Game.select_duplicate_cells(player_cells, type)
    puts "Duplicate cells: #{duplicate_cells}"
    dangerous_cell = cells.select { |cell| cell.send(type) == duplicate_cells.first && cell.value == ''}
    puts "Dangerous cell: #{dangerous_cell}"
    return dangerous_cell.first
  end

  def decide_optimal_move(cells, player_cells)
    winning_cell = check_win(cells, player_cells)
    if !!winning_cell
      winning_cell.value = 'O'
    elsif cells[4].value.empty?
      cells[4].value = 'O'
    else
      cells = move_adjacent_row(cells)
    end
    return cells
  end

  def check_win(cells, player_cells)
    ['row', 'column', 'right_x', 'left_x'].each do |type|
      winning_cell = get_winning_cell(cells, player_cells, type)
      if !!winning_cell
        return winning_cell
        break
      else
        next
      end
    end
    return nil
  end

  def get_winning_cell(cells, player_cells, type)
    ai_cells = Game.select_player_cells(cells, 'O')
    duplicate_cells = Game.select_duplicate_cells(ai_cells, type)
    puts "Duplicate cells: #{duplicate_cells}"
    winning_cell = cells.select { |cell| cell.send(type) == duplicate_cells.first && cell.value == ''}
    puts "Winning cell: #{winning_cell}"
    return winning_cell.first
  end

  def move_adjacent_row(cells)
    puts "Deciding row..."
    random_ai_cell = Game.select_player_cells(cells, 'O').sample
    empty_adjacent_cells = cells.select { |cell| cell.row == random_ai_cell.row && cell.value == '' }
    if empty_adjacent_cells.count == 2
      empty_adjacent_cells.sample.value = 'O'
    else
      cells = move_adjacent_column(cells)
    end
    return cells
  end

  def move_adjacent_column(cells)
    random_ai_cell = Game.select_player_cells(cells, 'O').sample
    empty_adjacent_cells = cells.select { |cell| cell.column == random_ai_cell.column && cell.value == '' }
    if empty_adjacent_cells.count == 2
      empty_adjacent_cells.sample.value = 'O'
    else
      cells = move_adjacent_left_x(cells)
    end
    return cells
  end

  def move_adjacent_left_x(cells)
    random_ai_cell = Game.select_player_cells(cells, 'O').sample
    empty_adjacent_cells = cells.select { |cell| cell.left_x == random_ai_cell.left_x && cell.value == '' }
    if empty_adjacent_cells.count == 2
      empty_adjacent_cells.sample.value = 'O'
    else
      cells = move_adjacent_right_x(cells)
    end
    return cells
  end

  def move_adjacent_right_x(cells)
    random_ai_cell = Game.select_player_cells(cells, 'O').sample
    empty_adjacent_cells = cells.select { |cell| cell.right_x == random_ai_cell.right_x && cell.value == '' }
    if empty_adjacent_cells.count == 2
      empty_adjacent_cells.sample.value = 'O'
    else
      cells = move_random_empty_cell(cells)
    end
    return cells
  end

  def move_random_empty_cell
    random_empty_cell = cells.select { |cell| cell.value == ''}.sample
    random_empty_cell.value = 'O'
    return cells
  end


end