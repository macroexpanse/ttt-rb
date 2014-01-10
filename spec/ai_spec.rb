require_relative '../ttt.rb'
require_relative '../lib/ai.rb'
require 'spec_helper.rb'

describe 'Ai Service' do
  let(:ai) { Ai.new }
  let(:cells) { Cell.parse_json(Cell::DEFAULT_JSON_CELLS) }
  let(:board) { Board.new('human_value' => 'X') }

  it 'responds to first move if in middle' do
    board.move = '1'
    cells[4].value = 'X'
    new_cells = ai.check_win(board, cells)
    new_cells[0].value.should == 'O'
  end

  it 'responds to first move if edge' do
    board.move = '1'
    cells[7].value = 'X'
    new_cells = ai.check_win(board, cells)
    new_cells[4].value.should == 'O'
  end

  it 'responds to first move if not in middle' do
    board.move = '1'
    cells[0].value = 'X'
    new_cells = ai.check_win(board, cells)
    new_cells[4].value.should == 'O'
  end

  it 'finds row danger' do
    cells[0].value = 'X'
    cells[1].value = 'X'
    dangerous_cell = ai.check_potential_wins(board, cells,[cells[0], cells[1]] )
    dangerous_cell.should == cells[2]
  end

  it 'finds column danger' do
    cells[0].value = 'X'
    cells[3].value = 'X'
    dangerous_cell = ai.check_potential_wins(board, cells,[cells[0], cells[3]] )
    dangerous_cell.should == cells[6]
  end

  it 'finds right_x danger' do
    cells[4].value = 'X'
    cells[2].value = 'X'
    dangerous_cell = ai.check_potential_wins(board, cells,[cells[2], cells[4]] )
    dangerous_cell.should == cells[6]
  end

  it 'responds to second move if first and last corner taken' do
    board.move = '2'
    cells[0].value = 'X'
    cells[8].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[5].value.should == 'O'
  end

  it 'responds to second move if middle and corner taken' do
    board.move = '2'
    cells[4].value = 'X'
    cells[8].value = 'X'
    cells[0].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[6].value.should == 'O'
  end

  it 'responds to second move if first two edges taken' do
    board.move = '2'
    cells[1].value = 'X'
    cells[5].value = 'X'
    cells[0].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[2].value.should == 'O'
  end

  it 'responds to second move if last two edges taken' do
    board.move = '2'
    cells[7].value = 'X'
    cells[5].value = 'X'
    cells[0].value = '0'
    new_cells = ai.check_win(board, cells)
    new_cells[8].value.should == 'O'
  end

  it 'responds to second move if 2 Xs in same row' do
    board.move = '2'
    cells[6].value = 'X'
    cells[8].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[7].value.should == 'O'
  end

  it 'responds to second move if 2 Xs in same column' do
    board.move = '2'
    cells[2].value = 'X'
    cells[8].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[5].value.should == 'O'
  end

  it 'responds to second move if 2 Xs associated diagonally' do
    board.move = '2'
    cells[4].value = 'X'
    cells[6].value = 'X'
    cells[0].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[2].value.should == 'O'
  end

  it 'responds to second move in top corner and opposite edge optimally by blocking' do
    board.move = '2'
    cells[0].value = 'X'
    cells[7].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[8].value.should == 'O'
  end

  it 'responds to second move in bottom corner and opposite edge optimally by blocking' do
    board.move = '2'
    cells[8].value = 'X'
    cells[1].value = 'X'
    cells[4].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[2].value.should == 'O'
  end

  it 'responds to third move if 2 Xs in the same row' do
    board.move = '3'
    cells[0].value = 'X'
    cells[3].value = 'X'
    cells[1].value = 'X'
    cells[4].value = 'O'
    cells[6].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[2].value.should == 'O'
  end

  it 'wins with third move if 3 Xs in top corner' do
    board.move = '3'
    cells[0].value = 'X'
    cells[3].value = 'X'
    cells[1].value = 'X'
    cells[4].value = 'O'
    cells[6].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[2].value.should == 'O'
  end

  it 'responds to edge third move optimally if right_x opening for win' do
    board.move = '3'
    cells[1].value = 'X'
    cells[2].value = 'X'
    cells[5].value = 'X'
    cells[0].value = 'O'
    cells[4].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[8].value.should == 'O'
  end

  it 'responds to fourth move by moving adjacent' do
    board.move = '4'
    cells[0].value = 'X'
    cells[8].value = 'X'
    cells[3].value = 'X'
    cells[2].value = 'X'
    cells[4].value = 'O'
    cells[5].value = 'O'
    cells[6].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[1].value.should == 'O'
  end

  it 'responds to right_x danger on fourth move' do
    board.move = '4'
    cells[4].value = 'X'
    cells[3].value = 'X'
    cells[1].value = 'X'
    cells[2].value = 'X'
    cells[0].value = 'O'
    cells[5].value = 'O'
    cells[1].value = 'O'
    new_cells = ai.check_win(board, cells)
    new_cells[6].value.should == 'O'
  end


end
