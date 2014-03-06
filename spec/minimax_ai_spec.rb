require 'minimax_ai'
require 'game_state'
require 'cell'
require 'board'
require 'spec_helper'

describe 'Minimax AI Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:ai_player) { Player.new({:name => 'ai', :value => 'X'}) }
  let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  context "3x3 board" do
    it "generates game tree and returns initial game state" do
      game_state =  minimax_ai.generate(ai_player, human_player, ai_player, 3) 
      expect(game_state.class).to eq GameState 
    end

    it 'blocks row' do
      cells = convert_array_to_minimax_cells(['O', 'O', nil, 
                                              nil, nil, nil, 
                                              'X', nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 
      
      expect(string_cells).to eq ['O', 'O', 'X', 
                                  nil, nil, nil, 
                                  'X', nil, nil]
    end  

    it 'wins row' do
      cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                              nil, nil, nil, 
                                              'O', 'O', nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', 'X', 'X', 
                                  nil, nil, nil, 
                                  'O', 'O', nil]
    end

    it 'blocks column' do
      cells = convert_array_to_minimax_cells(['O', 'X', nil, 
                                              'O', nil, nil, 
                                              nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['O', 'X', nil, 
                                  'O', nil, nil, 
                                  'X', nil, nil]
    end 

    it 'wins column' do
      cells = convert_array_to_minimax_cells(['X', nil, 'O', 
                                              'X', nil, 'O', 
                                              nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', nil, 'O', 
                                  'X', nil, 'O', 
                                  'X', nil, nil]
    end
    
    it 'blocks left diagonal' do 
      cells = convert_array_to_minimax_cells(['O', nil, nil, 
                                              nil, 'O', nil, 
                                              'X', nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['O', nil, nil, 
                                  nil, 'O', nil, 
                                  'X', nil, 'X']
    end

    it 'wins left diagonal' do
      cells = convert_array_to_minimax_cells(['X', nil, nil, 
                                              nil, 'X', nil, 
                                              'O', 'O', nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', nil, nil, 
                                  nil, 'X', nil, 
                                  'O', 'O', 'X']
    end

    it 'blocks right diagonal' do
      cells = convert_array_to_minimax_cells(['X', nil, 'O', 
                                              nil, 'O', nil, 
                                              nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', nil, 'O', 
                                  nil, 'O', nil, 
                                  'X', nil, nil]
    end

    it 'wins right diagonal' do
      cells = convert_array_to_minimax_cells(['O', nil, 'X', 
                                              'O', 'X', nil, 
                                              nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array       
      
      expect(string_cells).to eq ['O', nil, 'X', 
                                  'O', 'X', nil, 
                                  'X', nil, nil]
    end
  end 

  context "Pruning" do
    let(:game_state) { minimax_ai.generate(ai_player, human_player, ai_player, 3) }

    it 'prunes game tree when alpha >= beta' do
      minimax_ai.alpha_beta_pruning(game_state, 1, -1, 1)

      expect(game_state.count_moves).to eq 0
    end

    it 'prunes game tree when depth > 3' do
      depth = 4
      minimax_ai.depth_pruning(game_state, -100, 100, depth)

      expect(game_state.count_moves).to eq 0
    end

  end
  
  context "4x4 board" do
    it 'generates 4x4 board' do
      game_state = minimax_ai.generate(ai_player, human_player, ai_player, 4)
      array_cells = game_state.convert_cells_to_array
      expect(array_cells.count).to eq 16
    end 

    it 'forces first move to corner' do
      game_state = minimax_ai.generate(ai_player, human_player, ai_player, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq ['X', nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, nil]
    end  

    it 'forces first_move to bottom corner if top corner taken' do
      cells = convert_array_to_minimax_cells(['O', nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 1)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq ['O', nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, nil, 
                                  nil, nil, nil, 'X']
    end

    it 'blocks row' do
      cells = convert_array_to_minimax_cells(['O', 'O', 'O', nil,
                                              'X', nil, nil, nil,
                                              'X', nil, nil, nil,
                                              'X', nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq ['O', 'O', 'O', 'X',
                                  'X', nil, nil, nil,
                                  'X', nil, nil, nil,
                                  'X', nil, nil, nil]
    end

    it 'blocks column' do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X', 'X',
                                              'O', nil, nil, nil,
                                              'O', nil, nil, nil,
                                              nil, nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq ['O', 'X', 'X', 'X',
                                  'O', nil, nil, nil,
                                  'O', nil, nil, nil,
                                  'X', nil, nil, nil]
    end

    it 'blocks right diagonal' do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X', 'X',
                                              nil, 'O', nil, nil,
                                              nil, nil, 'O', nil,
                                              nil, nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq ['O', 'X', 'X', 'X',
                                  nil, 'O', nil, nil,
                                  nil, nil, 'O', nil,
                                  nil, nil, nil, 'X']
    end
  
    it 'blocks left diagonal' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'O',
                                              nil, nil, 'O', nil,
                                              nil, 'O', nil, nil,
                                              nil, nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq (['X', 'X', 'X', 'O',
                                   nil, nil, 'O', nil,
                                   nil, 'O', nil, nil,
                                   'X', nil, nil, nil])
    end

    it 'blocks corner fork' do
      cells = convert_array_to_minimax_cells([nil, 'O', 'O', nil,
                                              'X', 'X', 'X', 'O',
                                              nil, 'X', nil, 'O',
                                              nil, nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq  ['X', 'O', 'O', nil,
                                   'X', 'X', 'X', 'O',
                                   nil, 'X', nil, 'O',
                                   nil, nil, nil, nil]

    end

    it 'blocks right triangle fork' do
      cells = convert_array_to_minimax_cells(['O', 'X', 'X', 'X',
                                              'O', 'O', 'X', 'X',
                                              nil, 'O', 'O', nil,
                                              nil, nil, nil, 'X'])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      next_game_state = minimax_ai.next_move(game_state)
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq  ['O', 'X', 'X', 'X',
                                   'O', 'O', 'X', 'X',
                                   nil, 'O', 'O', 'X',
                                   nil, nil, nil, 'X']

    end
  end
end
