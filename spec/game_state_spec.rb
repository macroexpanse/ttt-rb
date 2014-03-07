require 'game_state'
require 'minimax_ai'
require 'cell'
require 'board'
require 'spec_helper'

describe 'Game State Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:ai_player) { Player.new({:name => 'ai', :value => 'X'})}
  let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
  let(:game_state) { minimax_ai.generate_initial_game_state(ai_player, human_player, ai_player, 3) }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  context '3x3 board' do
    it 'initializes board with no moves' do
      expect(game_state.count_moves).to eq 0
    end 

    it 'calculates winning rank for ai win' do
      cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                              nil, 'O', nil, 
                                              'O', nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_game_state = minimax_ai.next_move(game_state)

      expect(next_game_state.rank).to eq 1 
    end

    it 'calculates losing rank for ai loss' do
      cells = convert_array_to_minimax_cells(['X', nil, nil, 
                                              nil, nil, 'X', 
                                             'O', 'O', nil])
      game_state = GameState.new(ai_player, human_player, human_player, cells, 3)
      minimax_ai.next_move(game_state)

      expect(game_state.rank).to eq -0.9 
    end

    it 'calculates tie rank for tie' do
      cells = convert_array_to_minimax_cells(['O', 'X', 'O', 
                                              'O', 'X', nil, 
                                              'X', 'O', 'X'])

      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      minimax_ai.next_move(game_state)

      expect(game_state.rank).to eq 0
    end

    it 'determines next move based on maximum rank' do
      cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                              nil, nil, 'O', 
                                              'O', nil, nil])

      game_state = GameState.new(ai_player, human_player, ai_player, cells, 3)
      next_move = minimax_ai.next_move(game_state)

      expect(next_move.rank).to eq 1
    end

    it 'detects winning cells' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 
                                                          nil, nil, nil, 
                                                          nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      boolean = game_state.three_by_three_winning_positions?(cells, [0, 1, 2]) 
      expect(boolean).to eq true
    end

    it 'returns winning cell objects' do
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 
                                              nil, nil, nil, 
                                              nil, nil, nil])
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      winning_cells = [cells[0], cells[1], 
                       cells[2]]

      expect(game_state.get_winning_cells).to eq  winning_cells   
    end

    context "command line game" do
      it 'rejects move if cell is full' do
        cells = convert_array_to_minimax_cells(['X', nil, nil,
                                                nil, nil, nil,
                                                nil, nil, nil])
        game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
        boolean = game_state.cell_empty?(0)

        expect(boolean).to eq false
      end
    end
  end

  context "4x4 board" do
    let(:game_state) { minimax_ai.generate_initial_game_state('X', 'ai', 4) } 

    it "returns winning cell objects" do 
      cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'X',
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil,
                                              nil, nil, nil, nil])  
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 4)
      winning_cells = [cells[0], cells[1], 
                       cells[2], cells[3]]
      expect(game_state.get_winning_cells).to eq winning_cells
    end
    
  end
  
  context 'command line game' do
    it 'fills cell from user input' do
      game_state.fill_cell(0)
      array_cells = game_state.convert_cells_to_array

      expect(array_cells).to eq ['X', nil, nil,
                                 nil, nil, nil,
                                 nil, nil, nil]
    end
  end
end

