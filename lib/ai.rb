class Ai
  attr_reader :game_state, :board

  def initialize(game_state)
    @game_state = game_state
    @board = game_state.board
  end

  def next_move
    ai_cells = select_player_cells(ai_value)
    winning_cell = check_potential_wins(ai_cells) if game_state.turn > 2
    route_move if winning_cell.nil?
    cells
  end

  def cells
    board.cells
  end

  def ai_value
    game_state.ai_value
  end

  def human_value
    game_state.human_value
  end

  def route_move
    if game_state.turn == 1
      place_move_1
    elsif game_state.turn == 2
      place_move_2
    else
      place_subsequent_move
    end
  end

  def place_move_1
    if value_for_cell(4) == human_value
      make_move(0)
    else
      make_move(4)
    end
  end

  def value_for_cell(id)
    board.value_for_cell(id)
  end

  def make_move(id)
    board.fill_cell(id, ai_value)
  end

  def place_move_2
    human_cells = select_player_cells(human_value)
    check_expert_corner_moves(human_cells)
  end

  def check_expert_corner_moves(human_cells)
    if opposite_corners_taken?
      make_move(5)
    elsif corner_and_middle_taken?
      place_open_corner
    else
      check_expert_edge_moves(human_cells)
    end
  end

  def place_open_corner
    if value_for_cell(6).nil?
      make_move(6)
    else
      make_move(2)
    end
  end

  def check_expert_edge_moves(human_cells)
    if human_cell?(1) && human_cell?(5)
      make_move(2)
    elsif human_cell?(5) && human_cell?(7)
      make_move(8)
    else
      check_expert_corner_edge_moves(human_cells)
    end
  end

  def human_cell?(id)
    value_for_cell(id) == human_value
  end

  def check_expert_corner_edge_moves(human_cells)
    if human_cell?(0) && human_cell?(7)
      make_move(8)
    elsif human_cell?(2) && human_cell?(7)
      make_move(6)
    else
      make_danger_decision(human_cells)
    end
  end

  def place_subsequent_move
    human_cells = select_player_cells(human_value)
    make_danger_decision(human_cells)
  end

  def check_potential_wins(ai_cells)
    %w(row column right_x left_x).each do |type|
      winning_cell = get_winning_cell(type, ai_cells)
      if winning_cell
        assign_winning_cells(winning_cell, type) if ai_cells.first.value == ai_value
        return winning_cell
      end
    end
    nil
  end

  def get_winning_cell(type, ai_cells)
    duplicate_cells = select_duplicate_cells(ai_cells, type)
    game_state.cells.detect { |cell| cell.send(type) == duplicate_cells.first && cell.value.nil? }
  end

  def assign_winning_cells(winning_cell, type)
    make_move(winning_cell.id)
    winning_cells = cells.select { |cell| cell.send(type) == winning_cell.send(type) }
    winning_cells.map { |cell| cell.win = true }
  end

  def make_danger_decision(human_cells)
    dangerous_cell = check_potential_wins(human_cells)
    if dangerous_cell
      make_move(dangerous_cell.id)
    else
      decide_optimal_move
    end
  end

  def decide_optimal_move
    if value_for_cell(4).nil?
      make_move(4)
    else
      move_adjacent
    end
  end

  def move_adjacent
    %w(left_x right_x row column).each do |type|
      empty_adjacent_cells = select_adjacent_cells(type, nil)
      if empty_adjacent_cells.count == 2
        make_move(empty_adjacent_cells.first.id)
      end
    end
    move_first_empty_cell
  end

  def move_first_empty_cell
    first_empty_cell = game_state.cells.detect { |cell| cell.value.nil? }
    make_move(first_empty_cell.id) if first_empty_cell
  end

  def opposite_corners_taken?
    if value_for_cell(0) == human_value && value_for_cell(8) == human_value
      true
    elsif value_for_cell(2) == human_value && value_for_cell(6) == human_value
      true
    else
      false
    end
  end

  def corner_and_middle_taken?
    board.corner_taken? && value_for_cell(4) == human_value
  end

  def select_player_cells(player_value)
    cells.select { |c| c.value == player_value }
  end

  def select_duplicate_cells(player_cells, type)
    associations = player_cells.collect { |c| c.send(type) }
    associations.select { |association| associations.count(association) > 1 && association != false }.uniq
  end

  def select_adjacent_cells(type, value)
    first_ai_cell = select_player_cells(ai_value).first
    cells.select { |cell| cell.send(type) == first_ai_cell.send(type) && cell.send(type) != false && cell.value == value }
  end

end
