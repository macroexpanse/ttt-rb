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
    game_state.cells = convert_string_to_minimax_cells('O, O, nil, 
                                                       nil, nil, nil, 
                                                       X, nil, nil')
    game_state.turn = 4
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[2].value).to eq 'X'
  end  

  it 'wins row' do
    game_state.cells = convert_string_to_minimax_cells('X, X, nil, 
                                                       nil, nil, nil, 
                                                       O, O, nil')
    game_state.turn = 5
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[2].value).to eq 'X'
  end

  it 'blocks column' do
    game_state.cells = convert_string_to_minimax_cells('O, nil, nil, 
                                                        O, nil, nil, 
                                                        X, nil, nil')
    game_state.turn = 4
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[6].value).to eq 'X'
  end 

  it 'wins column' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, O, 
                                                        X, nil, O, 
                                                        nil, nil, nil')
    game_state.turn = 5
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[6].value).to eq 'X'
  end
  
  it 'blocks left diagonal' do 
    game_state.cells = convert_string_to_minimax_cells('O, nil, nil, 
                                                        nil, O, nil, 
                                                        X, nil, nil')
    game_state.turn = 4
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[8].value).to eq 'X'
  end

  it 'wins left diagonal' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, nil, 
                                                        nil, X, nil, 
                                                        O, O, nil')
    game_state.turn = 5
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[8].value).to eq 'X'
  end

  it 'blocks right diagonal' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, O, 
                                                        nil, O, nil, 
                                                        nil, nil, nil')
    game_state.turn = 4
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[6].value).to eq 'X'
  end

  it 'wins right diagonal' do
    game_state.cells = convert_string_to_minimax_cells('O, nil, X, 
                                                        O, X, nil, 
                                                       nil, nil, nil')
    game_state.turn = 5
    game_tree.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move

    expect(next_game_state.cells[6].value).to eq 'X'
  end

  context "Alpha-beta pruning" do
    
    it "sets alpha when max rank is greater than alpha" do
      game_state.cells = convert_string_to_minimax_cells('X, X, X, 
                                                         nil, O, nil,
                                                          O, nil, nil')
      new_alpha = game_tree.set_alpha_beta(game_state, game_state.current_player, alpha, beta) 

      expect(new_alpha).to eq 1
    end

    it 'sets beta when min rank is less than beta' do
      game_state.cells = convert_string_to_minimax_cells('nil, X, X, 
                                                          O, O, O, 
                                                         nil, nil, nil')
      game_state.current_player.name = 'human'
      game_state.current_player.value = 'O'
      new_beta = game_tree.set_alpha_beta(game_state, game_state.current_player, alpha, beta)
      expect(new_beta).to eq -1
    end
  end
end
