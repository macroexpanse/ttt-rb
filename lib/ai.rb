require_relative 'board'
require_relative '../ttt'

class Ai

  def check_win(board, cells)
    ai_cells = board.select_player_cells(cells, board.ai_value)
    winning_cell = check_potential_wins(board, cells, ai_cells) if board.turn > '2'
    cells = route_move(board, cells) if winning_cell.nil?
    cells
  end

  def route_move(board, cells)
    if board.turn == '1'
      place_move_1(board, cells)
    elsif board.turn == '2'
      place_move_2(board, cells)
    else
      place_subsequent_move(board, cells)
    end
  end

  def place_move_1(board, cells)
    if cells[4].value == board.human_value
      cells[0].value = board.ai_value
    else
      cells[4].value = board.ai_value
    end
    cells
  end

  def place_move_2(board, cells)
    player_cells = board.select_player_cells(cells, board.human_value)
    check_expert_corner_moves(board, cells, player_cells)
  end

  def check_expert_corner_moves(board, cells, player_cells)
    if board.opposite_corners_taken?(cells)
      cells[5].value = board.ai_value
    elsif board.corner_and_middle_taken?(cells)
      place_open_corner(board, cells)
    else
      check_expert_edge_moves(board, cells, player_cells)
    end
    cells
  end

  def place_open_corner(board, cells)
    if cells[6].value.nil?
      cells[6].value = board.ai_value
    else
      cells[2].value = board.ai_value
    end
    cells
  end

  def check_expert_edge_moves(board, cells, player_cells)
    if cells[1].value == board.human_value && cells[5].value == board.human_value
      cells[2].value = board.ai_value
    elsif cells[5].value == board.human_value && cells[7].value == board.human_value
      cells[8].value = board.ai_value
    else
      check_expert_corner_edge_moves(board, cells, player_cells)
    end
  end

  def check_expert_corner_edge_moves(board, cells, player_cells)
    if cells[0].value == board.human_value && cells[7].value == board.human_value
      cells[8].value = board.ai_value
    elsif cells[2].value == board.human_value && cells[7].value == board.human_value
      cells[6].value = board.ai_value
    else
      make_danger_decision(board, cells, player_cells)
    end
  end

  def place_subsequent_move(board, cells)
    player_cells = board.select_player_cells(cells, board.human_value)
    make_danger_decision(board, cells, player_cells)
  end

  def check_potential_wins(board, cells, player_cells)
    %w(row column right_x left_x).each do |type|
      winning_cell = get_winning_cell(board, cells, type, player_cells)
      if winning_cell
        assign_winning_cells(board, cells, winning_cell, type) if player_cells.first.value == board.ai_value
        return winning_cell
      end
    end
    nil
  end

  def get_winning_cell(board, cells, type, player_cells)
    duplicate_cells = board.select_duplicate_cells(player_cells, type)
    cells.select { |cell| cell.send(type) == duplicate_cells.first && cell.value.nil? }.first
  end

  def assign_winning_cells(board, cells, winning_cell, type)
    winning_cell.value = board.ai_value
    winning_cells = cells.select { |cell| cell.send(type) == winning_cell.send(type) }
    winning_cells.map { |cell| cell.win = true }
  end

  def make_danger_decision(board, cells, player_cells)
    dangerous_cell = check_potential_wins(board, cells, player_cells)
    if dangerous_cell
      dangerous_cell.value = board.ai_value
      cells
    else
      decide_optimal_move(board, cells)
    end
  end

  def decide_optimal_move(board, cells)
    if cells[4].value.nil?
      cells[4].value = board.ai_value
    else
      move_adjacent(board, cells)
    end
    cells
  end

  def move_adjacent(board, cells)
    %w(left_x right_x row column).each do |type|
      empty_adjacent_cells = board.select_adjacent_cells(cells, type, nil)
      if empty_adjacent_cells.count == 2
        empty_adjacent_cells.first.value = board.ai_value
        return cells
      end
    end
    move_first_empty_cell(board, cells)
  end

  def move_first_empty_cell(board, cells)
    first_empty_cell = cells.select { |cell| cell.value.nil? }.first
    first_empty_cell.value = board.ai_value if first_empty_cell
    cells
  end

end
