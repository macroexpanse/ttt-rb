class Ai

  def first_move(game)
    if game[:rows][1][:cells][1][:value] == 'X'
      game[:rows][0][:cells][0][:value] = 'O'
    else
      game[:rows][1][:cells][1][:value] = 'O'
    end
    return game 
  end
end