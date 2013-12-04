class Ai

  def first_move(game)
    if [game[:cells][0], game[:cells][2], game[:cells][6], game[:cells][8]].include?('X')
      game[:cells][4] = 'O'
    else
      game[:cells][0] = 'O'
    end
    return game 
  end

  def second_move(game)
    
  end
end