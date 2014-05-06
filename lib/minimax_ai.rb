require_relative '../lib/game_state'

class MinimaxAi

  MAX_RANK = 100
  MIN_RANK = -100

  def initialize(game_state)
    @game_state = game_state
    @height = @game_state.get_board_height
    @winning_combinations = winning_combinations
  end

  def winning_combinations
    winning_combinations = []
    @height.times do |i|
      winning_row_combination, winning_column_combination = [], []
      @height.times do |ii|
        winning_row_combination << (i * @height) + ii
        winning_column_combination << (ii * @height) + i
      end
     winning_combinations << winning_row_combination << winning_column_combination
    end
    winning_combinations + [left_diagonal_win, right_diagonal_win]
  end

  def left_diagonal_win
    (0..@height - 1).inject([]) do |diagonal, i|
      diagonal << i * (@height + 1)
    end
  end

  def right_diagonal_win
    (0..@height - 1).inject([]) do |diagonal, i|
      diagonal << (i + 1) * (@height - 1)
    end
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
    if @height.odd? && @game_state.cell_empty?(middle_cell_id)
      @game_state.fill_ai_cell(middle_cell_id)
    else
      @game_state.fill_random_corner_cell
    end
  end

  def get_best_possible_move(alpha = MIN_RANK, beta = MAX_RANK, depth = 0)
    best_move = nil
    max_rank = MIN_RANK
    @game_state.empty_cells.each do |cell|
      next_game_state = @game_state.duplicate_with_move(cell.id, @game_state.ai_player.value)
      rank = build_tree_for(next_game_state, alpha, beta, depth)
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

  def build_tree_for(game_state, alpha, beta, depth, value = @game_state.ai_player.value, opposite_value = @game_state.human_player.value)
    comp_rank = MIN_RANK**depth
    operator = (depth % 2 == 0) ? '<' : '>'
    winning_cells = get_winning_cells(game_state)
    if game_state.final_state?(winning_cells)
      rank_game_state(game_state) / (depth + 1)
    else
      return 0 if depth >= @height
      game_state.empty_cells.each do |cell|
        next_game_state = game_state.duplicate_with_move(cell.id, opposite_value)
        rank = build_tree_for(next_game_state, alpha, beta, depth + 1, opposite_value, value)
        alpha = rank if next_game_state.ai_player.value == opposite_value && rank > alpha
        beta = rank if next_game_state.human_player.value == opposite_value && rank < beta
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
    winning_combination = get_winning_combination(game_state)
    get_winning_cells_from_winning_combination(game_state, winning_combination)
  end

  def get_winning_combination(game_state)
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

  def get_winning_cells_from_winning_combination(game_state, winning_combination)
    (0..@height - 1).inject([]) do |winning_cells, i|
      winning_cells << game_state.cells[winning_combination[i]] rescue return
    end
  end

  def game_over?
    winning_cell_results = get_winning_cells(@game_state)
    @game_state.final_state?(winning_cell_results)
  end

  def draw?
    winning_cell_results = get_winning_cells(@game_state)
    @game_state.draw?(winning_cell_results)
  end

end
