require 'ai'
require 'board'
require 'spec_helper'

describe 'Board Service' do
  let(:ai) { Ai.new }

  it 'recognizes corner is taken' do
    cells = convert_array_to_regular_cells([nil, nil, nil,
                                            nil, nil, nil,
                                            nil, nil, 'O'])
    board = Board.new({:human_value => 'O', :cells => cells})
    expect(board.corner_taken?).to be_true
  end

  it 'recognizes opposite corners are taken' do
    cells = convert_array_to_regular_cells([nil, nil, 'O',
                                            nil, nil, nil,
                                            'O', nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    expect(board.opposite_corners_taken?).to be_true
  end

  it 'recognizes corner and middle are taken' do
    cells = convert_array_to_regular_cells(['O', nil, nil,
                                            nil, 'O', nil,
                                            nil, nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    expect(board.corner_and_middle_taken?).to be_true
  end

  it 'selects player cells' do
    cells = convert_array_to_regular_cells(['X', nil, nil,
                                            'O', 'O', nil,
                                             'O', nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    player_cells = board.select_player_cells(board.human_value)
    expect(player_cells).to eq [cells[3], cells[4], cells[6]]
  end

  it 'selects player cells in same row' do
    cells = convert_array_to_regular_cells([nil, nil, nil,
                                            'O', 'O', nil,
                                            'O', 'X', 'O'])
    board = Board.new({:human_value => 'O', :cells => cells})
    player_cells = board.select_player_cells(board.human_value)
    expect(board.select_duplicate_cells(player_cells, 'row')).to eq ['b', 'c']
  end

  it 'selects player cells in same column' do
    cells = convert_array_to_regular_cells(['O', 'X', 'O',
                                            'O', 'X', 'O',
                                            nil, nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    player_cells = board.select_player_cells(board.human_value)
    expect(board.select_duplicate_cells(player_cells, 'column')).to eq ['1', '3']
  end

  it 'selects player cells in right_x' do
    cells = convert_array_to_regular_cells([nil, nil, 'O',
                                            nil, 'O', nil,
                                            nil, nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    player_cells = board.select_player_cells(board.human_value)
    expect(board.select_duplicate_cells(player_cells, 'right_x')).to be_true
  end

  it 'selects empty cells in same row as ai cell' do
    cells = convert_array_to_regular_cells([nil, nil, nil,
                                            nil, 'X', nil,
                                            nil, nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    expect(board.select_adjacent_cells('row', nil)).to eq [cells[3], cells[5]]
  end

  it 'selects empty cells in same column as ai cell' do
    cells = convert_array_to_regular_cells([nil, nil, nil,
                                            nil, 'X', nil,
                                            nil, nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    expect(board.select_adjacent_cells('column', nil)).to eq [cells[1], cells[7]]
  end

  it 'selects empty cells in same x as ai cell' do
    cells = convert_array_to_regular_cells([nil, nil, nil,
                                            nil, 'X', nil,
                                            nil, nil, nil])
    board = Board.new({:human_value => 'O', :cells => cells})
    expect(board.select_adjacent_cells('right_x', nil)).to eq [cells[2], cells[6]]
  end

end
