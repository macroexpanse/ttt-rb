require_relative '../ttt'
require 'ai'
require 'spec_helper'

describe 'Ai Service' do
  let(:ai) { Ai.new }
  let(:board) { Board.new('human_value' => 'O') }

  it 'responds to first move if in middle' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                             nil, 'O', nil, 
                                             nil, nil, nil])
    board.turn = '1'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['X', nil, nil, 
                                nil, 'O', nil, 
                                nil, nil, nil]
  end

  it 'responds to first move if edge' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            nil, nil, nil, 
                                            nil,'O', nil])
    board.turn = '1'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq [nil, nil, nil, 
                                nil, 'X', nil, 
                                nil, 'O', nil]
  end

  it 'responds to first move if not in middle' do
    cells = convert_array_to_regular_cells(['O', nil, nil, 
                                             nil, nil, nil, 
                                             nil, nil, nil])
    board.turn = '1'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells)

    expect(string_cells).to eq ['O', nil, nil, 
                                nil, 'X', nil, 
                                nil, nil, nil]
  end

  it 'finds row danger' do
    cells = convert_array_to_regular_cells(['O', 'O', nil, 
                                            nil, nil, nil, 
                                            nil, nil, nil])
    dangerous_cell = ai.check_potential_wins(board, cells,[cells[0], cells[1]] )

    dangerous_cell.should == cells[2]
  end

  it 'finds column danger' do
    cells = convert_array_to_regular_cells(['O', nil, nil, 
                                            'O', nil, nil, 
                                            nil, nil, nil])
    dangerous_cell = ai.check_potential_wins(board, cells,[cells[0], cells[3]] )

    dangerous_cell.should == cells[6]
  end

  it 'finds right_x danger' do
    cells = convert_array_to_regular_cells([nil, nil, 'O', 
                                            nil, 'O', nil, 
                                            nil, nil, nil])
    dangerous_cell = ai.check_potential_wins(board, cells,[cells[2], cells[4]] )

    dangerous_cell.should == cells[6]
  end

  it 'responds to second move if first and last corner taken' do
    cells = convert_array_to_regular_cells(['O', nil, nil, 
                                            nil, 'X', nil, 
                                            nil, nil, 'O'])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['O', nil, nil, 
                                nil, 'X', 'X', 
                                nil, nil, 'O']
  end

  it 'responds to second move if middle and corner taken' do
    cells = convert_array_to_regular_cells(['X', nil, nil, 
                                            nil, 'O', nil, 
                                            nil, nil, 'O'])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['X', nil, nil, 
                                nil, 'O', nil, 
                                'X', nil, 'O']
  end

  it 'responds to second move if first two edges taken' do
    cells = convert_array_to_regular_cells(['X', 'O', nil, 
                                            nil, nil, 'O', 
                                            nil, nil, nil])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['X', 'O', 'X', 
                                nil, nil, 'O', 
                                nil, nil, nil]
  end

  it 'responds to second move if last two edges taken' do
    cells = convert_array_to_regular_cells(['X', nil, nil, 
                                            nil, nil, 'O', 
                                            nil, 'O', nil])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['X', nil, nil, 
                                nil, nil, 'O', 
                                nil, 'O', 'X']
  end

  it 'responds to second move if 2 Xs in same row' do
    cells = convert_array_to_regular_cells([nil, nil, nil, 
                                            nil, 'X', nil, 
                                            'O', nil, 'O'])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq [nil, nil, nil, 
                                nil, 'X', nil, 
                                'O', 'X', 'O']
  end

  it 'responds to second move if 2 Xs in same column' do
    cells = convert_array_to_regular_cells([nil, nil, 'O',
                                            nil, 'X', nil,
                                            nil, nil, 'O'])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 
    
    expect(string_cells).to eq [nil, nil, 'O', 
                                nil, 'X', 'X', 
                                nil, nil, 'O']
  end

  it 'responds to second move if 2 Xs associated diagonally' do
    cells = convert_array_to_regular_cells(['X', nil, nil, 
                                            nil, 'O', nil,
                                            'O', nil, nil])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['X', nil, 'X', 
                                nil, 'O', nil, 
                                'O', nil, nil]
  end

  it 'responds to second move in top corner and opposite edge optimally by blocking' do
    cells = convert_array_to_regular_cells(['O', nil, nil, 
                                            nil, 'X', nil, 
                                            'O', 'O', nil])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['O', nil, nil, 
                                nil, 'X', nil, 
                                'O', 'O', 'X']
  end

  it 'responds to second move in bottom corner and opposite edge optimally by blocking' do
    cells = convert_array_to_regular_cells([nil, 'O', nil, 
                                            nil, 'X', nil, 
                                            nil, nil, 'O'])
    board.turn = '2'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq [nil,'O', 'X', 
                                nil, 'X', nil, 
                                nil, nil, 'O']
  end 

  it 'responds to third move if 2 Xs in the same row' do
    cells = convert_array_to_regular_cells(['O', 'O', nil, 
                                            'O', 'X', nil, 
                                            'X', nil, nil])
    board.turn = '3'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['O', 'O', 'X',
                                'O', 'X', nil, 
                                'X', nil, nil]
  end

  it 'wins with third move if 3 Xs in top corner' do
    cells = convert_array_to_regular_cells(['O', 'O', nil, 
                                            'O', 'X', nil, 
                                            'X', nil, nil])
    board.turn = '3'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['O', 'O', 'X', 
                                'O', 'X', nil, 
                                'X', nil, nil]
  end

  it 'responds to edge third move optimally if right_x opening for win' do
    cells = convert_array_to_regular_cells(['X', 'O', 'O', 
                                             nil, 'X', 'O', 
                                             nil, nil, nil])
    board.turn = '3'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['X', 'O', 'O', 
                                nil, 'X', 'O', 
                                nil, nil, 'X']
  end

  it 'responds to fourth move by moving adjacent' do
    cells = convert_array_to_regular_cells(['O', nil, 'O', 
                                            'O', 'X', 'X', 
                                            'X', nil, 'O'])
    board.turn = '4'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['O', 'X', 'O', 
                                'O', 'X', 'X', 
                                'X', nil, 'O']
  end

  it 'responds to right_x danger on fourth move' do
    cells = convert_array_to_regular_cells(['X', 'X', 'O', 
                                             'O', 'O', 'X', 
                                             nil, nil, nil])
    board.turn = '4'
    new_cells = ai.check_win(board, cells)
    string_cells = convert_cells_to_array(new_cells) 

    expect(string_cells).to eq ['X', 'X', 'O', 
                                'O', 'O', 'X', 
                                'X', nil, nil]
  end


end
