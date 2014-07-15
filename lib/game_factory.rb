require './lib/board'
require './lib/simple_ai'
require './lib/player'
require './lib/win_conditions'
require './lib/game_state'
require './lib/rules'
require './lib/minimax_ai'
require './lib/cell'

class GameFactory
  attr_reader :params, :game_state

  def build(params)
    @params = params
    @board_height = params[:board_height].to_i
    human_player = Player.new(:name => "human", :value => params[:human_value])
    ai_player = Player.new(:name => "ai", :value => human_player.opposite_value)
    win_conditions = WinConditions.new(:board_height => @board_height)
    rules = Rules.new(:win_conditions => win_conditions)
    board = Board.new(:cells => cells)
    @game_state = GameState.new(:ai_player => ai_player, :human_player => human_player,
                                :board => board, :turn => params[:turn], :rules => rules)
    decide_game_type(params, game_state)
  end

  private

  def decide_game_type(params, game_state)
    if params[:ai_type] == "simple"
      [game_state, SimpleAi.new(game_state)]
    else
      [game_state, MinimaxAi.new(game_state)]
    end
  end

  def cells
    params[:cells] || Cell.generate_default_cells(:board_height => @board_height)
  end
end
