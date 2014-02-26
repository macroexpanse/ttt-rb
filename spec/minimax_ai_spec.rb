require 'minimax_ai.rb'
require 'game_state.rb'
require 'cell.rb'
require 'board.rb'
require 'spec_helper.rb'
require_relative '../ttt.rb'

describe 'Minimax AI Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:game_state) { minimax_ai.generate('X') }
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
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 
    
    expect(string_cells).to eq 'O, O, X, nil, nil, nil, X, nil, nil'
  end  

  it 'wins row' do
    game_state.cells = convert_string_to_minimax_cells('X, X, nil, 
                                                       nil, nil, nil, 
                                                       O, O, nil')
    game_state.turn = 5
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 

    expect(string_cells).to eq 'X, X, X, nil, nil, nil, O, O, nil'
  end

  it 'blocks column' do
    game_state.cells = convert_string_to_minimax_cells('O, X, nil, 
                                                        O, nil, nil, 
                                                        nil, nil, nil')
    game_state.turn = 4
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 

    expect(string_cells).to eq 'O, X, nil, O, nil, nil, X, nil, nil' 
  end 

  it 'wins column' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, O, 
                                                        X, nil, O, 
                                                        nil, nil, nil')
    game_state.turn = 5
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 

    expect(string_cells).to eq 'X, nil, O, X, nil, O, X, nil, nil'
  end
  
  it 'blocks left diagonal' do 
    game_state.cells = convert_string_to_minimax_cells('O, nil, nil, 
                                                        nil, O, nil, 
                                                        X, nil, nil')
    game_state.turn = 4
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 

    expect(string_cells).to eq 'O, nil, nil, nil, O, nil, X, nil, X'
  end

  it 'wins left diagonal' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, nil, 
                                                        nil, X, nil, 
                                                        O, O, nil')
    game_state.turn = 5
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 

    expect(string_cells).to eq 'X, nil, nil, nil, X, nil, O, O, X'
  end

  it 'blocks right diagonal' do
    game_state.cells = convert_string_to_minimax_cells('X, nil, O, 
                                                        nil, O, nil, 
                                                        nil, nil, nil')
    game_state.turn = 4
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 

    expect(string_cells).to eq 'X, nil, O, nil, O, nil, X, nil, nil'
  end

  it 'wins right diagonal' do
    game_state.cells = convert_string_to_minimax_cells('O, nil, X, 
                                                        O, X, nil, 
                                                       nil, nil, nil')
    game_state.turn = 5
    minimax_ai.prune(game_state, alpha, beta)
    next_game_state = game_state.next_move
    string_cells = convert_cells_to_string(next_game_state.cells) 
    
    expect(string_cells).to eq 'O, nil, X, O, X, nil, X, nil, nil'
  end

  context "Alpha-beta pruning" do
    
    it "sets alpha when max rank is greater than alpha" do
      game_state.cells = convert_string_to_minimax_cells('X, X, X, 
                                                         nil, O, nil,
                                                          O, nil, nil')
      new_alpha = minimax_ai.set_alpha_beta(game_state, game_state.current_player, alpha, beta) 

      expect(new_alpha).to eq 1
    end

    it 'sets beta when min rank is less than beta' do
      game_state.cells = convert_string_to_minimax_cells('nil, X, X, 
                                                          O, O, O, 
                                                         nil, nil, nil')
      game_state.current_player.name = 'human'
      game_state.current_player.value = 'O'
      new_beta = minimax_ai.set_alpha_beta(game_state, game_state.current_player, alpha, beta)
      expect(new_beta).to eq -1
    end
  end
end
