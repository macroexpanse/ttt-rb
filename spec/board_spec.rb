require_relative '../ttt.rb'
require_relative '../lib/ai.rb'
require_relative '../lib/board.rb'
require 'spec_helper.rb'

describe 'Board Service' do
  let(:ai) { Ai.new }
  let(:cells) { Cell.parse_json(Cell.create_default_json_cells) }
  let(:board) { Board.new({'human_value' => 'O'})}

  it 'recognizes corner is taken' do
  	cells[8].value = board.human_value
  	board.corner_taken?(cells).should == true
  end

  it 'recognizes opposite corners are taken' do
  	cells[2].value = board.human_value
  	cells[6].value = board.human_value
  	board.opposite_corners_taken?(cells).should == true
  end

  it 'recognizes corner and middle are taken' do
  	cells[4].value = board.human_value
  	cells[0].value = board.human_value
  	board.corner_and_middle_taken?(cells).should == true
  end

  it 'selects player cells' do
  	cells[3].value = board.human_value
  	cells[4].value = board.human_value
  	cells[6].value = board.human_value
  	cells[0].value = board.ai_value
  	board.select_player_cells(cells, board.human_value).should == [cells[3], cells[4], cells[6]]
  end

  it 'selects player cells in same row' do
  	cells[3].value = board.human_value
  	cells[4].value = board.human_value
  	cells[6].value = board.human_value
  	cells[8].value = board.human_value
  	cells[7].value = board.ai_value
  	player_cells = board.select_player_cells(cells, board.human_value)
  	board.select_duplicate_cells(player_cells, 'row').should == ['b', 'c']
  end

  it 'selects player cells in same column' do
  	cells[0].value = board.human_value
  	cells[3].value = board.human_value
  	cells[2].value = board.human_value
  	cells[5].value = board.human_value
  	cells[1].value = board.ai_value
  	cells[4].value = board.ai_value
  	player_cells = board.select_player_cells(cells, board.human_value)
  	board.select_duplicate_cells(player_cells, 'column').should == ['1', '3']
  end

  it 'selects player cells in right_x' do
  	cells[2].value = board.human_value
  	cells[4].value = board.human_value
  	player_cells = board.select_player_cells(cells, board.human_value)
  	board.select_duplicate_cells(player_cells, 'right_x').should == [true]
  end

  it 'selects empty cells in same row as ai cell' do
  	cells[4].value = board.ai_value
  	board.select_adjacent_cells(cells, 'row', '').should == [cells[3], cells[5]]
  end

  it 'selects empty cells in same column as ai cell' do
  	cells[4].value = board.ai_value
  	board.select_adjacent_cells(cells, 'column', '').should == [cells[1], cells[7]]
  end

  it 'selects empty cells in same x as ai cell' do
  	cells[4].value = board.ai_value
  	board.select_adjacent_cells(cells, 'right_x', '').should == [cells[2], cells[6]]
  end

end