class Ai

  def check_win(move, cells)
    player_cells = Game.select_player_cells(cells, 'X')
    winning_cell = check_potential_wins(cells, player_cells)
    cells = route_move(move, cells, player_cells) if winning_cell.nil?
    return cells
  end

  def route_move(move, cells, player_cells)
    if move == '1' || move == '2'
      cells = self.send("place_move_#{move}", cells, player_cells) 
    else
      cells = place_subsequent_move(cells, player_cells) 
    end
  end

  def check_potential_wins(cells, player_cells)
    ['row', 'column', 'right_x', 'left_x'].each do |type|
      winning_cell = get_winning_cell(cells, player_cells, type)
      if !!winning_cell
        assign_winning_cells(cells, winning_cell, type)
        return winning_cell
        break
      end
    end
    return nil
  end

  def get_winning_cell(cells, player_cells, type)
    ai_cells = Game.select_player_cells(cells, 'O')
    duplicate_cells = Game.select_duplicate_cells(ai_cells, type)
    winning_cell = cells.select { |cell| cell.send(type) == duplicate_cells.first && cell.value == ''}.first
    return winning_cell
  end

  def place_move_1(cells, player_cells)
    if cells[4].value == 'X'
      cells[0].value = 'O'
    else
      cells[4].value = 'O'
    end
    return cells
  end

  def place_move_2(cells, player_cells)
    dangerous_cell = check_danger(cells, player_cells)
    cells = check_expert_moves(cells, player_cells, dangerous_cell)
  end

  def check_expert_moves(cells, player_cells, dangerous_cell)
    if Game.opposite_corners_taken?(cells)
      cells[5].value = 'O'
    elsif Game.corner_and_middle_taken?(cells)
      cells = place_open_corner(cells)
    elsif cells[1].value == 'X' && cells[5].value == 'X'
      cells[2].value = 'O'
    elsif cells[5].value == 'X' && cells[7].value == 'X'
      cells[8].value = 'O'
    else
      cells = make_danger_decision(cells, player_cells, dangerous_cell)
    end
    return cells
  end

  def place_open_corner(cells)
    if cells[6].value == ''
      cells[6].value = 'O'  
    else 
      cells[2].value = 'O'
    end
    return cells
  end

  def make_danger_decision(cells, player_cells, dangerous_cell)
    if !!dangerous_cell
      dangerous_cell.value = 'O'
      return cells
    else
      cells = decide_optimal_move(cells)
    end
  end

  def place_subsequent_move(cells, player_cells)
    dangerous_cell = check_danger(cells, player_cells)
    cells = make_danger_decision(cells, player_cells, dangerous_cell)
  end

  def check_danger(cells, player_cells)
    ['row', 'column', 'right_x'].each do |type|
      dangerous_cell = get_dangerous_cell(cells, player_cells, type)
      if !!dangerous_cell
        return dangerous_cell
        break
      end
    end
    return nil
  end

  def get_dangerous_cell(cells, player_cells, type)
    duplicate_cells = Game.select_duplicate_cells(player_cells, type)
    dangerous_cells = cells.select { |cell| cell.send(type) == duplicate_cells.first && cell.value == ''}
    return dangerous_cells.first
  end

  def decide_optimal_move(cells)
    if cells[4].value.empty?
      cells[4].value = 'O'
    else
      cells = move_adjacent(cells)
    end
    return cells
  end

  def assign_winning_cells(cells, winning_cell, type)
    winning_cell.value = 'O'
    winning_cell.win = true
    other_winning_cells = cells.select { |cell| cell.send(type) == winning_cell.send(type) }
    other_winning_cells.map { |cell| cell.win = true }
  end

  def move_adjacent(cells)
    ['left_x', 'right_x', 'row', 'column'].each do |type|
      empty_adjacent_cells = Game.select_adjacent_cells(cells, type, '')
      player_adjacent_cells = Game.select_adjacent_cells(cells, type, 'X')
      if empty_adjacent_cells.count == 1 && player_adjacent_cells.count == 1
        empty_adjacent_cells.first.value = 'O'
        return cells
        break
      end
    end
    cells = move_first_empty_cell(cells)
  end

  def move_first_empty_cell(cells)
    first_empty_cell = cells.select { |cell| cell.value == ''}.first
    first_empty_cell.value = 'O' if !!first_empty_cell
    return cells
  end

end