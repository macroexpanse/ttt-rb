class GameState
  attr_reader :board, :human_player, :ai_player, :turn, :rules

  def initialize(args)
    @board = args[:board]
    @ai_player = args[:ai_player]
    @human_player = args[:human_player]
    @rules = args[:rules]
    @turn = Integer(args[:turn])
  end

  def duplicate_with_move(id, value)
    dup = Marshal.load(Marshal.dump(self))
    dup.fill_cell(id, value)
    dup
  end

  def fill_cell(id, value)
    board.fill_cell(id, value)
  end

  def fill_human_cell(id)
    fill_cell(id, human_value)
  end

  def human_value
    human_player.value
  end

  def fill_ai_cell(id)
    fill_cell(id, ai_value)
  end

  def ai_value
    ai_player.value
  end

  def winning_cells
    rules.get_winning_cells(board)
  end

  def game_over?
    rules.game_over?(board)
  end

  def increment_turn
    @turn += 1
  end

end
