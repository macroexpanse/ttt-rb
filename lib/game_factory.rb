require './lib/board'
require './lib/simple_ai'
require './lib/player'
require './lib/win_conditions'
require './lib/game_state'
require './lib/rules'
require './lib/minimax_ai'
require './lib/cell_factory'

class GameFactory
  def build(params)
    @human_player = Player.new(:name => "human", :value => params[:human_value])
    @ai_player = Player.new(:name => "ai", :value => @human_player.opposite_value)
    win_conditions = WinConditions.new(:board_height => params[:board_height].to_i)
    @rules = Rules.new(:win_conditions => win_conditions)
    params[:ai_type] == "simple" ? simple_ai_game(params) : minimax_ai_game(params)
  end

  private

  def simple_ai_game(params)
    cells = params[:cells] || generate_cells(params, SimpleAiCell)
    board = Board.new(:cells => cells)
    game_state = GameState.new(:ai_player => @ai_player, :human_player => @human_player,
                               :board => board, :turn => params[:turn], :rules => @rules)
    [game_state, SimpleAi.new(game_state)]
  end

  def minimax_ai_game(params)
    cells = params[:cells] || generate_cells(params, Cell)
    board = Board.new(:cells => cells)
    game_state = GameState.new(:ai_player => @ai_player, :human_player => @human_player,
                               :board => board, :turn => params[:turn], :rules => @rules)
    [game_state, MinimaxAi.new(game_state)]
  end

  def generate_cells(params, cell_type)
    CellFactory.new.generate_cells(:board_height => params[:board_height], :cell => cell_type)
  end

end
