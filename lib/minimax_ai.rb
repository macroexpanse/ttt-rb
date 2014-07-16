class MinimaxAi
  attr_reader :game_state, :board

  MAX_RANK = 100
  MIN_RANK = -100

  def initialize(game_state)
    @game_state = game_state
    @board = game_state.board
  end

  def next_move
    if forceable_turn?
      force_turn
    else
      cell_index = get_best_possible_move
      unless game_state.game_over?
        game_state.fill_ai_cell(cell_index)
        game_state.increment_turn
      end
      set_win if game_state.game_over? && !game_state.draw?
    end
    game_state
  end

  private

  def forceable_turn?
    game_state.turn < (board_height - 1)
  end

  def board_height
    board.height
  end

  def force_turn
    middle_cell_id = board.middle_cell.id
    if board_height.odd? && board.cell_empty?(middle_cell_id)
      game_state.fill_ai_cell(middle_cell_id)
    else
      fill_random_corner_cell
    end
  end

  def fill_random_corner_cell
    unfilled_corner_cell = board.corner_cells.shuffle.detect { |cell| cell.value.nil? }
    game_state.fill_ai_cell(unfilled_corner_cell.id)
  end

  def get_best_possible_move(alpha = MIN_RANK, beta = MAX_RANK, depth = 0)
    best_move = nil
    max_rank = MIN_RANK
    board.empty_cells.each do |cell|
      next_game_state = game_state.duplicate_with_move(cell.id, game_state.ai_player.value)
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

  def build_tree_for(game_state, alpha, beta, depth, value = game_state.ai_value, opposite_value = game_state.human_value)
    comp_rank = MIN_RANK**depth
    operator = (depth % 2 == 0) ? '<' : '>'
    if game_state.game_over?
      rank(game_state) / (depth + 1)
    else
      return 0 if depth >= board_height
      game_state.board.empty_cells.each do |cell|
        next_game_state = game_state.duplicate_with_move(cell.id, opposite_value)
        rank = build_tree_for(next_game_state, alpha, beta, depth + 1, opposite_value, value)
        alpha = rank if next_game_state.ai_value == opposite_value && rank > alpha
        beta = rank if next_game_state.human_value == opposite_value && rank < beta
        comp_rank = rank if rank.send(operator, comp_rank)
        break if alpha > beta
      end
      comp_rank
    end
  end

  def rank(game_state)
    winning_cells = game_state.winning_cells
    if winning_cells
      winning_cells.first.value == game_state.ai_value ? 1 : -1
    else
      0
    end
  end

  def set_win
    ids = game_state.winning_cells.collect { |cell| cell.id }
    winning_cells = board.cells.select { |cell| ids.include?(cell.id) }
    winning_cells.map { |cell| cell.is_winner }
  end
end
