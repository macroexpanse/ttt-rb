require 'minimax_ai'
require 'game_state'
require 'cell'
require 'player'
require 'spec_helper'

describe 'Minimax AI Service' do
  let(:ai_player) { Player.new({:name => 'ai', :value => 'X'}) }
  let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
  let(:cells) { Cell.generate_default_cells(3) }
  let(:game_state) { GameState.new(ai_player, human_player, ai_player, cells, 3) }
  let(:minimax_ai) { MinimaxAi.new(game_state) }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  context "3x3 board" do

    it 'blocks row' do
      cells = convert_array_to_minimax_cells(['O', 'O', nil, 
                                              nil, nil, nil, 
                                              'X', nil, nil])

      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 
      
      expect(string_cells).to eq ['O', 'O', 'X', 
                                  nil, nil, nil, 
                                  'X', nil, nil]
    end  

    it 'wins row' do
      cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                              nil, nil, nil, 
                                              'O', 'O', nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', 'X', 'X', 
                                  nil, nil, nil, 
                                  'O', 'O', nil]
    end

    it 'blocks column' do
      cells = convert_array_to_minimax_cells(['O', 'X', nil, 
                                              'O', nil, nil, 
                                              nil, nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['O', 'X', nil, 
                                  'O', nil, nil, 
                                  'X', nil, nil]
    end 

    it 'wins column' do
      cells = convert_array_to_minimax_cells(['X', nil, 'O', 
                                              'X', nil, 'O', 
                                              nil, nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', nil, 'O', 
                                  'X', nil, 'O', 
                                  'X', nil, nil]
    end
    
    it 'blocks left diagonal' do 
      cells = convert_array_to_minimax_cells(['O', nil, nil, 
                                              nil, 'O', nil, 
                                              'X', nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['O', nil, nil, 
                                  nil, 'O', nil, 
                                  'X', nil, 'X']
    end

    it 'wins left diagonal' do
      cells = convert_array_to_minimax_cells(['X', nil, nil, 
                                              nil, 'X', nil, 
                                              'O', 'O', nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', nil, nil, 
                                  nil, 'X', nil, 
                                  'O', 'O', 'X']
    end

    it 'blocks right diagonal' do
      cells = convert_array_to_minimax_cells(['X', nil, 'O', 
                                              nil, 'O', nil, 
                                              nil, nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array 

      expect(string_cells).to eq ['X', nil, 'O', 
                                  nil, 'O', nil, 
                                  'X', nil, nil]
    end

    it 'wins right diagonal' do
      cells = convert_array_to_minimax_cells(['O', nil, 'X', 
                                              'O', 'X', nil, 
                                              nil, nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array       
      
      expect(string_cells).to eq ['O', nil, 'X', 
                                  'O', 'X', nil, 
                                  'X', nil, nil]
    end
  end 

  context "Pruning" do
    let(:cells) { Cell.generate_default_cells(3) } 
    let(:game_state) { GameState.new(ai_player, human_player, ai_player, cells, 1) }
    let(:minimax_ai) { MinimaxAi.new(game_state) }

    it 'prunes game tree when alpha >= beta' do
      cell_index = minimax_ai.get_best_possible_move(100, -100, 1)

      expect(cell_index).to eq 0
    end

    it 'prunes game tree when depth > 3' do
      depth = 4
      cell_index = minimax_ai.get_best_possible_move(-100, 100, depth)

      expect(cell_index).to eq 0
    end

  end
  
  context "4x4 board" do
    let(:cells) { Cell.generate_default_cells(4) }
    let(:game_state) { GameState.new(ai_player, human_player, ai_player, cells, 3) }
    it 'generates 4x4 board' do
      array_cells = game_state.convert_cells_to_array
      expect(array_cells.count).to eq 16
    end 

    it 'forces first move to random corner' do
      game_state.turn = 1
      next_game_state = minimax_ai.next_move
      corner_cells = game_state.get_corner_cells
      corner_cell_values = corner_cells.collect { |cell| cell.value }

      expect(corner_cell_values).to include 'X' 
    end  

    it 'forces first_move to random corner if top corner taken' do
      game_state.turn = 1
      cells = convert_array_to_minimax_cells(['O', nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])
      game_state.turn = 1
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      corner_cells = next_game_state.get_corner_cells
      corner_cell_values = corner_cells.collect { |cell| cell.value }

      expect(corner_cell_values).to include 'X' 
    end

    it 'blocks row' do
      cells = convert_array_to_minimax_cells(['O', 'O', 'O', nil,
                                              'X', nil, nil, nil,
                                              'X', nil, nil, nil,
                                              'X', nil, nil, nil])
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
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
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
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
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
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
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
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
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
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
      game_state.cells = cells
      next_game_state = minimax_ai.next_move
      string_cells = next_game_state.convert_cells_to_array

      expect(string_cells).to eq  ['O', 'X', 'X', 'X',
                                   'O', 'O', 'X', 'X',
                                   nil, 'O', 'O', 'X',
                                   nil, nil, nil, 'X']

    end
  end
end
