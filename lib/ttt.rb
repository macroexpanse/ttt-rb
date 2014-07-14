require 'json'
require_relative '../lib/game_state'
require_relative '../lib/minimax_ai'
require_relative '../lib/ai'
require_relative '../lib/board'
require_relative '../lib/cell'
require_relative '../lib/player'

class TTT

  def initialize(human_player, ai_player)
    @minimax_ai = MinimaxAi.new
    @ai = Ai.new
    @human_player = human_player
    @ai_player = ai_player
  end

  def web_game(params)
    params = JSON.parse(params)
    cells = sort_and_build_cells(params)
    new_game_state = start_turn(params, cells)
    new_cells = new_game_state.cells
    sort_and_tear_down_cells(new_cells)
  end

  def sort_and_build_cells(params)
    array_of_hash_cells = params.select { |param| param.to_s.include?('cell') }.values
    cells = Cell.build(array_of_hash_cells, params["ai"])
    cells.sort_by! { |cell| cell.id }
  end

  def sort_and_tear_down_cells(new_cells)
    hash_cells = new_cells.map { |cell| cell.to_hash }
    hash_cells.sort_by! { |hash| hash["id"] }
  end

  def start_turn(params, cells)
    if params["ai"] == 'minimax'
      setup_minimax_game(params, cells)
    else
      setup_non_minimax_game(params, cells)
    end
  end

  def setup_minimax_game(params, cells)
    ai_value = params["human_value"] == 'X' ? 'O' : 'X'
    @ai_player.value = ai_value
    @human_player.value = params["human_value"]
    game_state = GameState.new(@ai_player, @human_player, cells, params["turn"].to_i)
    @minimax_ai = MinimaxAi.new(game_state)
    calculate_minimax_first_move
  end

  def calculate_minimax_first_move
    new_game_state = @minimax_ai.next_move
    game_state = new_game_state unless new_game_state.nil?
    game_state
  end

  def setup_non_minimax_game(params, cells)
    board = Board.new({:cells => cells, :turn => params["turn"], :human_value => params["human_value"]})
    @ai = Ai.new(board)
    @ai.check_win
  end

end


