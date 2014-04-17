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
      @game_state.fill_random_corner_cell
    else
      cell_index = get_best_possible_move(-100, 100, 0)
      @game_state.fill_cell(cell_index)
      @game_state.increment_turn
    end
    @game_state
  end

  def get_best_possible_move(alpha, beta, depth)
    best_move = nil
    max_rank = -1.0/0
    @game_state.empty_cells.each do |cell|
      next_game_state = @game_state.duplicate_with_move(cell.id) 
      rank = build_tree_for(next_game_state, cell.id, alpha, beta, depth)
      alpha = rank if next_game_state.current_player_is?("ai") && rank > alpha
      beta = rank if next_game_state.current_player_is?("human") && rank < beta
      if rank > max_rank
        max_rank = rank
        best_move = cell.id 
      end
      break if alpha >= beta
    end
    best_move
  end

  def build_tree_for(game_state, cell_index, alpha, beta, depth)
    comp_rank = (-1.0/0)**depth
    operator = (depth % 2 == 0) ? '<' : '>'
    winning_cells = get_winning_cells(game_state)
    if game_state.final_state?(winning_cells) 
      rank_game_state(game_state) / (depth + 1)
    else
      return 0 if (depth + 1) >= game_state.get_board_height
      game_state.empty_cells.each do |cell| 
        next_game_state = game_state.duplicate_with_move(cell_index) 
        next_game_state.switch_current_player
        rank = build_tree_for(next_game_state, cell.id, alpha, beta, depth + 1)
        alpha = rank if next_game_state.current_player_is?("ai") && rank > alpha
        beta = rank if next_game_state.current_player_is?("human") && rank < beta
        comp_rank = rank if rank.send(operator, comp_rank)
        break if alpha >= beta
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
    unless game_state.cells[positions[0]].value.nil?
      positions.each_cons(2) do |current_position, next_position|
        comparison = game_state.cells[current_position].value == game_state.cells[next_position].value
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
