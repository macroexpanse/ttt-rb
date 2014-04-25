require_relative '../lib/game_state'

class MinimaxAi

  def initialize(game_state)
    @game_state = game_state
    @winning_combinations = get_winning_combinations
  end

  def get_winning_combinations
    board_height = @game_state.get_board_height
    potential_winning_combinations = []
    winning_left_diagonal_combination = []
    winning_right_diagonal_combination = []
    board_height.times do |i|
      winning_row_combination = []
      winning_column_combination = []
      board_height.times do |ii|
        winning_row_combination << (i * board_height) + ii
        winning_column_combination << (ii * board_height) + i
      end
      winning_left_diagonal_combination << winning_row_combination[i]
      winning_right_diagonal_combination << winning_row_combination[board_height - i - 1]
      potential_winning_combinations << winning_row_combination
      potential_winning_combinations << winning_column_combination
    end
    potential_winning_combinations << winning_left_diagonal_combination
    potential_winning_combinations << winning_right_diagonal_combination
  end

  def next_move
    if @game_state.forceable_turn?
      force_turn
    else
      cell_index = get_best_possible_move
      @game_state.fill_ai_cell(cell_index)
      @game_state.increment_turn
    end
    @game_state
  end

  def force_turn
    middle_cell_id = @game_state.get_middle_cell.id
    if @game_state.get_board_size.odd? && @game_state.cell_empty?(middle_cell_id)
      @game_state.fill_ai_cell(middle_cell_id)
    else
      @game_state.fill_random_corner_cell
    end
  end

  def get_best_possible_move(alpha = -100, beta = 100, depth = 0)
    best_move = nil
    max_rank = -1.0/0
    @game_state.empty_cells.each do |cell|
      next_game_state = @game_state.duplicate_with_move(cell.id, @game_state.ai_player.value)
      rank = build_tree_for(next_game_state, alpha, beta, depth, @game_state.ai_player.value, @game_state.human_player.value)
      alpha = rank if rank > alpha
      beta = rank if rank < beta
      if rank > max_rank
        max_rank = rank
        best_move = cell.id
      end
      break if alpha > beta
    end
    best_move
  end

  def build_tree_for(game_state, alpha, beta, depth, value, opposite_value)
    comp_rank = (-1.0/0)**depth
    operator = (depth % 2 == 0) ? '<' : '>'
    winning_cells = get_winning_cells(game_state)
    if game_state.final_state?(winning_cells)
      rank_game_state(game_state) / (depth + 1)
    else
      return 0 if depth >= game_state.get_board_height
      game_state.empty_cells.each do |cell|
        next_game_state = game_state.duplicate_with_move(cell.id, opposite_value)
        rank = build_tree_for(next_game_state, alpha, beta, depth + 1, opposite_value, value)
        alpha = rank if next_game_state.value_is?("ai", opposite_value) && rank > alpha
        beta = rank if next_game_state.value_is?("human", opposite_value) && rank < beta
        comp_rank = rank if rank.send(operator, comp_rank)
        break if alpha > beta
      end
      comp_rank
    end
  end

  def rank_game_state(game_state)
    winning_cells = get_winning_cells(game_state)
    if winning_cells
      game_state.winning_cells_are_ai_cells?(winning_cells) ? 1 : -1
    else
      0
    end
  end

  def get_winning_cells(game_state)
    board_height = game_state.get_board_height
    winning_combination = get_winning_combination(game_state, board_height)
    get_winning_cells_from_winning_combination(game_state, board_height, winning_combination)
  end

  def get_winning_combination(game_state, board_height)
    winning_combination = @winning_combinations.detect do |combination|
      winning_combination?(game_state, combination)
    end
  end

  def winning_combination?(game_state, positions)
    unless game_state.cell_empty?(positions[0])
      positions.each_cons(2) do |current_position, next_position|
        comparison = game_state.get_cell_value(current_position) == game_state.get_cell_value(next_position)
        return false if comparison == false
      end
      true
    end
  end

  def get_winning_cells_from_winning_combination(game_state, board_height, winning_combination)
    winning_cells = []
    board_height.times do |index|
      winning_cell = game_state.cells[winning_combination[index]] rescue return
      winning_cells << game_state.cells[winning_combination[index]]
    end
    winning_cells
  end

end
