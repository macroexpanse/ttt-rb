require './lib/ai'
require './lib/board'
require './lib/minimax_ai'
require './lib/player'
require './lib/game_state'
require './lib/cell'

class RulesFactory
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def build
    params[:ai_type] == "simple" ? simple_ai : minimax_ai
  end

  private

  def simple_ai
    board = Board.new({:turn => params[:turn], :human_value => params[:human_value]})
    ai = Ai.new(board)
    [board, ai]
  end

  def minimax_ai
    human_player = Player.new({:name => "human", :value => params[:human_value]})
    ai_player = Player.new({:name => "ai", :value => human_player.opposite_value})
    game_state = GameState.new(ai_player, human_player, cells, params[:turn])
    minimax_ai = MinimaxAi.new(game_state)
    [game_state, minimax_ai]
  end

  def cells
    params[:cells] || Cell.generate_default_cells(params[:board_height])
  end
end
