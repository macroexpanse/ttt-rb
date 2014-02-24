require 'game_tree.rb'
require 'game_state.rb'
require 'cell.rb'
require 'board.rb'
require 'spec_helper.rb'
require_relative '../ttt.rb'

describe 'Game Tree Service' do
  let(:game_tree) { GameTree.new }
  let(:game_state) { game_tree.generate('X') }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  it "generates game tree and returns initial game state" do
    expect(game_state.class).to eq GameState 
  end

  it 'blocks row' do
    game_state.cells[0].value = 'O'
    game_state.cells[6].value = 'X'
    game_state.cells[1].value = 'O'
    game_state.move = 4
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[2].value).to eq 'X'
  end  

  it 'wins row' do
    game_state.cells[0].value = 'X'
    game_state.cells[6].value = 'O'
    game_state.cells[1].value = 'X'
    game_state.cells[7].value = 'O'
    game_state.move = 5
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[2].value).to eq 'X'
  end

  it 'blocks column' do
    game_state.cells[0].value = 'O'
    game_state.cells[6].value = 'X'
    game_state.cells[3].value = 'O'
    game_state.move = 4
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[6].value).to eq 'X'
  end 

  it 'wins column' do
    game_state.cells[0].value = 'X'
    game_state.cells[2].value = 'O'
    game_state.cells[3].value = 'X'
    game_state.cells[5].value = 'O'
    game_state.move = 5
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[6].value).to eq 'X'
  end
  
  it 'blocks left diagonal' do 
    game_state.cells[0].value = 'O'
    game_state.cells[6].value = 'X'
    game_state.cells[4].value = 'O'
    game_state.move = 4
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[8].value).to eq 'X'
  end

  it 'wins left diagonal' do
    game_state.cells[0].value = 'X'
    game_state.cells[6].value = 'O'
    game_state.cells[4].value = 'X'
    game_state.cells[7].value = 'O'
    game_state.move = 5
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[8].value).to eq 'X'
  end

  it 'blocks right diagonal' do
    game_state.cells[2].value = 'O'
    game_state.cells[0].value = 'X'
    game_state.cells[4].value = 'O'
    game_state.move = 4
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[6].value).to eq 'X'
  end

  it 'wins right diagonal' do
    game_state.cells[2].value = 'X'
    game_state.cells[0].value = 'O'
    game_state.cells[4].value = 'X'
    game_state.cells[3].value = 'O'
    game_state.move = 5
    game_tree.generate_moves(game_state, alpha, beta)
    next_game_state = game_state.next_move
    expect(next_game_state.cells[6].value).to eq 'X'
  end

end
