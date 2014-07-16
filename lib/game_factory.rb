require './lib/board'
require './lib/simple_ai'
require './lib/player'
require './lib/game_state'
require './lib/rules'
require './lib/minimax_ai'
require './lib/cell_factory'

class GameFactory

  def build(params)
    @human_player = Player.new(:name => "human", :value => params[:human_value])
    @ai_player = Player.new(:name => "ai", :value => @human_player.opposite_value)
    params[:ai_type] == "simple" ? simple_ai_game(params) : minimax_ai_game(params)
  end

  private

  def simple_ai_game(params)
    cells = params[:cells] || generate_cells(params, 'simple')
    board = Board.new(:cells => cells)
    rules = Rules.new(:board => board)
    game_state = GameState.new(:ai_player => @ai_player, :human_player => @human_player,
                               :board => board, :turn => params[:turn], :rules => rules)
    [game_state, SimpleAi.new(game_state)]
  end

  def minimax_ai_game(params)
    cells = params[:cells] || generate_cells(params, 'minimax')
    board = Board.new(:cells => cells)
    rules = Rules.new(:board => board)
    game_state = GameState.new(:ai_player => @ai_player, :human_player => @human_player,
                               :board => board, :turn => params[:turn], :rules => rules)
    [game_state, MinimaxAi.new(game_state)]
  end

  def generate_cells(params, ai_type)
    CellFactory.new(:ai_type => ai_type).generate_cells(:board_height => params[:board_height])
  end

end
