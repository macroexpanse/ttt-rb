require 'minimax_ai.rb'
require 'game_state.rb'
require 'cell.rb'
require 'board.rb'
require 'spec_helper.rb'
require_relative '../ttt.rb'

describe 'Minimax AI Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:game_state) { minimax_ai.generate('X', 3) }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  context "3x3 board" do
    
    it "generates game tree and returns initial game state" do
      expect(game_state.class).to eq GameState 
    end

    it 'blocks row' do
      game_state.cells = convert_array_to_minimax_cells(['O', 'O', nil, 
                                                         nil, nil, nil, 
                                                         'X', nil, nil])
      game_state.turn = 2
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 
      
      expect(string_cells).to eq ['O', 'O', 'X', 
                                  nil, nil, nil, 
                                  'X', nil, nil]
    end  

    it 'wins row' do
      game_state.cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                                         nil, nil, nil, 
                                                         'O', 'O', nil])
      game_state.turn = 3
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['X', 'X', 'X', 
                                  nil, nil, nil, 
                                  'O', 'O', nil]
    end

    it 'blocks column' do
      game_state.cells = convert_array_to_minimax_cells(['O', 'X', nil, 
                                                          'O', nil, nil, 
                                                          nil, nil, nil])
      game_state.turn = 2
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['O', 'X', nil, 
                                  'O', nil, nil, 
                                  'X', nil, nil]
    end 

    it 'wins column' do
      game_state.cells = convert_array_to_minimax_cells(['X', nil, 'O', 
                                                          'X', nil, 'O', 
                                                          nil, nil, nil])
      game_state.turn = 3
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['X', nil, 'O', 
                                  'X', nil, 'O', 
                                  'X', nil, nil]
    end
    
    it 'blocks left diagonal' do 
      game_state.cells = convert_array_to_minimax_cells(['O', nil, nil, 
                                                          nil, 'O', nil, 
                                                          'X', nil, nil])
      game_state.turn = 2
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['O', nil, nil, 
                                  nil, 'O', nil, 
                                  'X', nil, 'X']
    end

    it 'wins left diagonal' do
      game_state.cells = convert_array_to_minimax_cells(['X', nil, nil, 
                                                          nil, 'X', nil, 
                                                          'O', 'O', nil])
      game_state.turn = 3
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['X', nil, nil, 
                                  nil, 'X', nil, 
                                  'O', 'O', 'X']
    end

    it 'blocks right diagonal' do
      game_state.cells = convert_array_to_minimax_cells(['X', nil, 'O', 
                                                          nil, 'O', nil, 
                                                          nil, nil, nil])
      game_state.turn = 2
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['X', nil, 'O', 
                                  nil, 'O', nil, 
                                  'X', nil, nil]
    end

    it 'wins right diagonal' do
      game_state.cells = convert_array_to_minimax_cells(['O', nil, 'X', 
                                                          'O', 'X', nil, 
                                                         nil, nil, nil])
      game_state.turn = 3
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 
      
      expect(string_cells).to eq ['O', nil, 'X', 
                                  'O', 'X', nil, 
                                  'X', nil, nil]
    end
  end 

  context "Pruning" do
    it 'prunes game tree when alpha >= beta' do
      minimax_ai.alpha_beta_pruning(game_state, 1, -1)

      expect(game_state.moves.count).to eq 0
    end

    it 'prunes game tree when depth > 3' do
      game_state.depth = 5
      minimax_ai.depth_pruning(game_state, -100, 100)

      expect(game_state.moves.count).to eq 0
    end

  end
  
  context "4x4 board" do
  let(:game_state) { minimax_ai.generate('X', 4) } 
   
    it 'generates 4x4 board' do
      expect(game_state.cells.count).to eq 16
    end 

    it 'forces first move to corner' do
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells)

      expect(string_cells).to eq ['X', nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, nil]
    end  

    it 'forces first_move to bottom corner if top corner taken' do
      game_state.cells = convert_array_to_minimax_cells(['O', nil, nil, nil,
                                                         nil, nil, nil, nil,
                                                         nil, nil, nil, nil,
                                                         nil, nil, nil, nil])

      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells)

      expect(string_cells).to eq ['O', nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, 'X']
    end

    it 'blocks row' do
      game_state.cells = convert_array_to_minimax_cells(['O', 'O', 'O', nil,
                                                         'X', nil, nil, nil,
                                                         'X', nil, nil, nil,
                                                         'X', nil, nil, nil])
      game_state.turn = 4
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = convert_cells_to_array(next_game_state.cells) 

      expect(string_cells).to eq ['O', 'O', 'O', 'X',
                                  'X', nil, nil, nil,
                                  'X', nil, nil, nil,
                                  'X', nil, nil, nil]
    end
  end

end
