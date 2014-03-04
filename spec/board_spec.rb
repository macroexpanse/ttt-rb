require 'ai'
require 'board'
require 'spec_helper'

describe 'Board Service' do
  let(:ai) { Ai.new }
  let(:board) { Board.new({'human_value' => 'O'})}

  it 'recognizes corner is taken' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            nil, nil, nil, 
                                            nil, nil, 'O'])
  	board.corner_taken?(cells).should == true
  end

  it 'recognizes opposite corners are taken' do
    cells = convert_array_to_regular_cells([nil, nil, 'O', 
                                            nil, nil, nil,
                                            'O', nil, nil])
  	board.opposite_corners_taken?(cells).should == true
  end

  it 'recognizes corner and middle are taken' do
    cells = convert_array_to_regular_cells(['O', nil, nil, 
                                            nil, 'O', nil, 
                                            nil, nil, nil])
  	board.corner_and_middle_taken?(cells).should == true
  end

  it 'selects player cells' do
    cells = convert_array_to_regular_cells(['X', nil, nil, 
                                            'O', 'O', nil, 
                                             'O', nil, nil])
  	board.select_player_cells(cells, board.human_value).should == [cells[3], cells[4], cells[6]]
  end

  it 'selects player cells in same row' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            'O', 'O', nil, 
                                            'O', 'X', 'O'])
  	player_cells = board.select_player_cells(cells, board.human_value)
  	board.select_duplicate_cells(player_cells, 'row').should == ['b', 'c']
  end

  it 'selects player cells in same column' do
    cells = convert_array_to_regular_cells(['O', 'X', 'O', 
                                            'O', 'X', 'O', 
                                            nil, nil, nil])
  	player_cells = board.select_player_cells(cells, board.human_value)
  	board.select_duplicate_cells(player_cells, 'column').should == ['1', '3']
  end

  it 'selects player cells in right_x' do
    cells = convert_array_to_regular_cells([nil, nil, 'O', 
                                            nil, 'O', nil,
                                            nil, nil, nil])
  	player_cells = board.select_player_cells(cells, board.human_value)
  	board.select_duplicate_cells(player_cells, 'right_x').should == [true]
  end

  it 'selects empty cells in same row as ai cell' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            nil, 'X', nil, 
                                            nil, nil, nil])
  	board.select_adjacent_cells(cells, 'row', nil).should == [cells[3], cells[5]]
  end

  it 'selects empty cells in same column as ai cell' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            nil, 'X', nil, 
                                            nil, nil, nil])
  	board.select_adjacent_cells(cells, 'column', nil).should == [cells[1], cells[7]]
  end

  it 'selects empty cells in same x as ai cell' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            nil, 'X', nil,
                                            nil, nil, nil])
  	board.select_adjacent_cells(cells, 'right_x', nil).should == [cells[2], cells[6]]
  end

end
