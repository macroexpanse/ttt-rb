require_relative 'board.rb'

class Ai

  def check_win(move, cells)
    ai_cells = Board.select_player_cells(cells, 'O')
    winning_cell = check_potential_wins(cells, ai_cells) if move > '2'
    cells = route_move(move, cells) if winning_cell.nil?
    return cells
  end

  def route_move(move, cells)
    if move == '1' || move == '2'
      cells = self.send("place_move_#{move}", cells) 
    else
      cells = place_subsequent_move(cells) 
    end
  end

  def place_move_1(cells)
    if cells[4].value == 'X'
      cells[0].value = 'O'
    else
      cells[4].value = 'O'
    end
    return cells
  end

  def place_move_2(cells)
    player_cells = Board.select_player_cells(cells, 'X')
    cells = check_expert_corner_moves(cells, player_cells)
  end

  def check_expert_corner_moves(cells, player_cells)
    if Board.opposite_corners_taken?(cells)
      cells[5].value = 'O'
    elsif Board.corner_and_middle_taken?(cells)
      cells = place_open_corner(cells)
    else
      check_expert_edge_moves(cells, player_cells)
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

  def check_expert_edge_moves(cells, player_cells)
    if cells[1].value == 'X' && cells[5].value == 'X'
      cells[2].value = 'O'
    elsif cells[5].value == 'X' && cells[7].value == 'X'
      cells[8].value = 'O'
    else
      check_expert_corner_edge_moves(cells, player_cells)
    end
  end

  def check_expert_corner_edge_moves(cells, player_cells)
    if cells[0].value == 'X' && cells[7].value == 'X'
      cells[8].value = 'O'
    elsif cells[2].value == 'X' && cells[7].value == 'X'
      cells[6].value = 'O'
    else
      cells = make_danger_decision(cells, player_cells)
    end
  end

  def place_subsequent_move(cells)
    player_cells = Board.select_player_cells(cells, 'X')
    cells = make_danger_decision(cells, player_cells)
  end

  def check_potential_wins(cells, player_cells)
    ['row', 'column', 'right_x', 'left_x'].each do |type|
      winning_cell = get_winning_cell(cells, type, player_cells)
      if !!winning_cell
        assign_winning_cells(cells, winning_cell, type) if player_cells.first.value == 'O'
        return winning_cell
        break
      end
    end
    return nil
  end

  def get_winning_cell(cells, type, player_cells)
    duplicate_cells = Board.select_duplicate_cells(player_cells, type)
    winning_cell = cells.select { |cell| cell.send(type) == duplicate_cells.first && cell.value == ''}.first
  end

  def assign_winning_cells(cells, winning_cell, type)
    winning_cell.value = 'O'
    winning_cells = cells.select { |cell| cell.send(type) == winning_cell.send(type) }
    winning_cells.map { |cell| cell.win = true }
  end

  def make_danger_decision(cells, player_cells)
    dangerous_cell = check_potential_wins(cells, player_cells)
    if !!dangerous_cell
      dangerous_cell.value = 'O'
      return cells
    else
      cells = decide_optimal_move(cells)
    end
  end

  def decide_optimal_move(cells)
    if cells[4].value.empty?
      cells[4].value = 'O'
    else
      cells = move_adjacent(cells)
    end
    return cells
  end

  def move_adjacent(cells)
    ['left_x', 'right_x', 'row', 'column'].each do |type|
      empty_adjacent_cells = Board.select_adjacent_cells(cells, type, '')
      if empty_adjacent_cells.count == 2
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