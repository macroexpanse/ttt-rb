require_relative '../ttt.rb'
require_relative '../lib/ai.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Board Service' do
  let(:ai) { Ai.new }
  let(:cells) { Cell.parse_json(Cell::DEFAULT_JSON_CELLS) }
  let(:board) { Board.new({'human_value' => 'X'})}

  it 'recognizes corner is taken' do
  	cells[8].value = 'X'
  	board.corner_taken?(cells).should == true
  end

  it 'recognizes opposite corners are taken' do
  	cells[2].value = 'X'
  	cells[6].value = 'X'
  	board.opposite_corners_taken?(cells).should == true
  end

  it 'recognizes corner and middle are taken' do
  	cells[4].value = 'X'
  	cells[0].value = 'X'
  	board.corner_and_middle_taken?(cells).should == true
  end

  it 'selects player cells' do
  	cells[3].value = 'X'
  	cells[4].value = 'X'
  	cells[6].value = 'X'
  	cells[0].value = 'O'
  	board.select_player_cells(cells, 'X').should == [cells[3], cells[4], cells[6]]
  end

  it 'selects player cells in same row' do
  	cells[3].value = 'X'
  	cells[4].value = 'X'
  	cells[6].value = 'X'
  	cells[8].value = 'X'
  	cells[7].value = 'O'
  	player_cells = board.select_player_cells(cells, 'X')
  	board.select_duplicate_cells(player_cells, 'row').should == ['b', 'c']
  end

  it 'selects player cells in same column' do
  	cells[0].value = 'X'
  	cells[3].value = 'X'
  	cells[2].value = 'X'
  	cells[5].value = 'X'
  	cells[1].value = 'O'
  	cells[4].value = 'O'
  	player_cells = board.select_player_cells(cells, 'X')
  	board.select_duplicate_cells(player_cells, 'column').should == ['1', '3']
  end

  it 'selects player cells in right_x' do
  	cells[2].value = 'X'
  	cells[4].value = 'X'
  	player_cells = board.select_player_cells(cells, 'X')
  	board.select_duplicate_cells(player_cells, 'right_x').should == [true]
  end

  it 'selects empty cells in same row as ai cell' do
  	cells[4].value = 'O'
  	board.select_adjacent_cells(cells, 'row', '').should == [cells[3], cells[5]]
  end

  it 'selects empty cells in same column as ai cell' do
  	cells[4].value = 'O'
  	board.select_adjacent_cells(cells, 'column', '').should == [cells[1], cells[7]]
  end

  it 'selects empty cells in same x as ai cell' do
  	cells[4].value = 'O'
  	board.select_adjacent_cells(cells, 'right_x', '').should == [cells[2], cells[6]]
  end

end