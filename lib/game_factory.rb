require './lib/board'
require './lib/ai'
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
    human_player = Player.new({:name => "human", :value => params[:human_value]})
    ai_player = Player.new({:name => "ai", :value => human_player.opposite_value})
    win_conditions = WinConditions.new(params[:board_height])
    rules = Rules.new(:win_conditions => win_conditions)
    board = Board.new(:cells => cells)
    @game_state = GameState.new(:ai_player => ai_player, :human_player => human_player,
                               :board => board, :turn => params[:turn], :rules => rules)
    params[:ai_type] == "simple" ? simple_game : minimax_game
  end

  private

  def simple_game
    ai = Ai.new(game_state)
    [game_state, ai]
  end

  def minimax_game
    minimax_ai = MinimaxAi.new(game_state)
    [game_state, minimax_ai]
  end

  def cells
    params[:cells] || Cell.generate_default_cells(params[:board_height])
  end
end
