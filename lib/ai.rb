require_relative 'board'

class Ai

  def initialize(board)
    @board = board
  end

  def check_win
    ai_cells = @board.select_player_cells(@board.ai_value)
    winning_cell = check_potential_wins(ai_cells) if @board.turn > '2'
    route_move if winning_cell.nil?
    @board.cells
  end

  def route_move
    if @board.turn == '1'
      place_move_1
    elsif @board.turn == '2'
      place_move_2
    else
      place_subsequent_move
    end
  end

  def place_move_1
    if @board.get_cell_value(4) == @board.human_value
      @board.fill_cell(0)
    else
      @board.fill_cell(4)
    end
  end

  def place_move_2
    human_cells = @board.select_player_cells(@board.human_value)
    check_expert_corner_moves(human_cells)
  end

  def check_expert_corner_moves(human_cells)
    if @board.opposite_corners_taken?
      @board.fill_cell(5)
    elsif @board.corner_and_middle_taken?
      place_open_corner
    else
      check_expert_edge_moves(human_cells)
    end
  end

  def place_open_corner
    if @board.get_cell_value(6).nil?
      @board.fill_cell(6)
    else
      @board.fill_cell(2)
    end
  end

  def check_expert_edge_moves(human_cells)
    if @board.human_cell?(1) && @board.human_cell?(5)
      @board.fill_cell(2)
    elsif @board.human_cell?(5) && @board.human_cell?(7)
      @board.fill_cell(8)
    else
      check_expert_corner_edge_moves(human_cells)
    end
  end

  def check_expert_corner_edge_moves(human_cells)
    if @board.human_cell?(0) && @board.human_cell?(7)
      @board.fill_cell(8)
    elsif @board.human_cell?(2) && @board.human_cell?(7)
      @board.fill_cell(6)
    else
      make_danger_decision(human_cells)
    end
  end

  def place_subsequent_move
    human_cells = @board.select_player_cells(@board.human_value)
    make_danger_decision(human_cells)
  end

  def check_potential_wins(ai_cells)
    %w(row column right_x left_x).each do |type|
      winning_cell = get_winning_cell(type, ai_cells)
      if winning_cell
        assign_winning_cells(winning_cell, type) if ai_cells.first.value == @board.ai_value
        return winning_cell
      end
    end
    nil
  end

  def get_winning_cell(type, ai_cells)
    duplicate_cells = @board.select_duplicate_cells(ai_cells, type)
    @board.cells.detect { |cell| cell.send(type) == duplicate_cells.first && cell.value.nil? }
  end

  def assign_winning_cells(winning_cell, type)
    @board.fill_cell(winning_cell.id)
    @board.set_winning_cells(winning_cell, type)
  end

  def make_danger_decision(human_cells)
    dangerous_cell = check_potential_wins(human_cells)
    if dangerous_cell
      @board.fill_cell(dangerous_cell.id)
    else
      decide_optimal_move
    end
  end

  def decide_optimal_move
    if @board.get_cell_value(4).nil?
      @board.fill_cell(4)
    else
      move_adjacent
    end
  end

  def move_adjacent
    %w(left_x right_x row column).each do |type|
      empty_adjacent_cells = @board.select_adjacent_cells(type, nil)
      if empty_adjacent_cells.count == 2
        @board.fill_cell(empty_adjacent_cells.first.id)
      end
    end
    move_first_empty_cell
  end

  def move_first_empty_cell
    first_empty_cell = @board.cells.detect { |cell| cell.value.nil? }
    @board.fill_cell(first_empty_cell.id) if first_empty_cell
  end

end
