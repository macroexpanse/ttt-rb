class Ai

  def which_move(move, cells)
    case move
      when '1'
        cells = first_move(cells)
      when '2'
        cells = second_move(cells)
    end
    return cells
  end

  def first_move(cells)
    if [cells[0]['value'],cells[2]['value'],cells[6]['value'],cells[8]['value']].include?('X')
     cells[4]['value'] = 'O'
    else
     cells[0]['value'] = 'O'
    end
    return cells
  end

  def second_move(cells)
    player_cells = get_player_cells(cells)
    danger_type = check_danger(player_cells)
    if !!danger_type
      cells = resolve_danger(cells, player_cells, danger_type)
    elsif cells[0]['value'] == 'X' && cells[8]['value'] == 'X'
      cells[5]['value'] = 'O'
    end
    return cells
  end

  def check_danger(player_cells)
    ['row', 'column', 'right_x'].each do |type|
      if danger?(player_cells, type)
        return type
        break
      else
        next
      end
    end
    return nil
  end

  def danger?(player_cells, type)
    case type
      when 'row'
        player_cells[0]['row'] == player_cells[1]['row']
      when 'column'
        player_cells[0]['column'] == player_cells[1]['column']
      when 'right_x'
        !!player_cells[0]['right_x'] && !!player_cells[1]['right_x']
    end
  end

  def resolve_danger(cells, player_cells, danger_type)
    association_type = ASSOCIATIONS[danger_type]
    associations = player_cells.collect { |c| c[association_type] }
    [0,1,2].each do |association|
      unless associations.include?(association)
        cells = block_danger(association, danger_type, cells, player_cells)
        break
      end
    end
    return cells
  end

  def block_danger(association, danger_type, cells, player_cells)
    case danger_type
      when 'row'
        new_cell_id = association + (player_cells[0]['row'] * 3)
      when 'column'
        new_cell_id = player_cells[0]['column'] + (association * 3)
      when 'right_x'
        new_cell_id = RIGHT_X_LOCATOR[association]
    end
    cells[new_cell_id.to_i]['value'] = 'O'
    return cells    
  end

  def get_player_cells(cells)
    player_cells = cells.collect { |c| c if c['value'] == 'X' }
    player_cells.compact
  end

  RIGHT_X_LOCATOR = {
    0 => 2,
    1 => 4,
    2 => 6
  }.freeze

  ASSOCIATIONS = {
    'row' => 'column',
    'column' => 'row',
    'right_x' => 'right_x'
  }.freeze

end