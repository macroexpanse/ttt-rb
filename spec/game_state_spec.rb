require 'game_state'
require 'minimax_ai'
require 'cell'
require 'board'
require 'spec_helper'

describe 'Game State Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:game_state) { minimax_ai.generate('X', 'ai', 3) }
  let(:alpha) { -100 }
  let(:beta) { 100 }

  it "initializes with no moves" do
   expect(game_state.moves).to eq []
  end

  context '3x3 board' do
    it 'calculates winning rank for ai win' do
      game_state.cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                                          nil, 'O', nil, 
                                                          'O', nil, nil])
      game_state.current_player.value = 'X'
      game_state.current_player.name = 'ai'
      game_state.turn = 3
      minimax_ai.next_move(game_state)

      expect(minimax_ai.rank(game_state)).to eq 0.9
    end

    it 'calculates losing rank for ai loss' do
      game_state.cells = convert_array_to_minimax_cells(['X', nil, nil, 
                                                          nil, nil, 'X', 
                                                          'O', 'O', nil])
      game_state.current_player.name = 'human'
      game_state.current_player.value = 'O'
      game_state.turn = 3
      minimax_ai.next_move(game_state)

      expect(minimax_ai.rank(game_state)).to eq -0.9 
    end

    it 'calculates tie rank for tie' do
      game_state.cells = convert_array_to_minimax_cells(['O', 'X', 'O', 
                                                          'O', 'X', nil, 
                                                          'X', 'O', 'X'])
      game_state.turn = 3
      minimax_ai.next_move(game_state)

      expect(minimax_ai.rank(game_state)).to eq 0
    end

    it 'determines next move based on maximum rank' do
      game_state.cells = convert_array_to_minimax_cells(['X', 'X', nil, 
                                                          nil, nil, 'O', 
                                                          'O', nil, nil])
      game_state.turn = 3 
      next_move = minimax_ai.next_move(game_state)

      expect(minimax_ai.rank(next_move)).to eq 1
    end

    it 'detects winning cells' do
      game_state.cells = convert_array_to_minimax_cells(['X', 'X', 'X', 
                                                          nil, nil, nil, 
                                                          nil, nil, nil])
      game_state.turn = 4
      boolean = game_state.three_by_three_winning_positions?(game_state.cells, [0, 1, 2]) 

      expect(boolean).to eq true
    end

    it 'returns winning cell objects' do
      game_state.cells = convert_array_to_minimax_cells(['X', 'X', 'X', 
                                                         nil, nil, nil, 
                                                         nil, nil, nil])
      game_state.turn = 4
      winning_cells = [game_state.cells[0], game_state.cells[1], 
                       game_state.cells[2]]

      expect(game_state.get_winning_cells).to eq  winning_cells   
    end

    context "command line game" do
      it 'rejects move if cell is full' do
        game_state.cells = convert_array_to_minimax_cells(['X', nil, nil,
                                                            nil, nil, nil,
                                                            nil, nil, nil])
        boolean = game_state.cell_empty?(0)

        expect(boolean).to eq false
      end
    end

    it 'checks user input' do
       
    end

  end

  context "4x4 board" do
    let(:game_state) { minimax_ai.generate('X', 'ai', 4) } 

    it "returns winning cell objects" do 
      game_state.cells = convert_array_to_minimax_cells(['X', 'X', 'X', 'X',
                                                          nil, nil, nil, nil,
                                                          nil, nil, nil, nil,
                                                          nil, nil, nil, nil])  
      winning_cells = [game_state.cells[0], game_state.cells[1], 
                       game_state.cells[2], game_state.cells[3]]
      expect(game_state.get_winning_cells).to eq winning_cells
    end
    
  end
  
  context 'command line game' do
    it 'fills cell from user input' do
      game_state.fill_cell_from_user_input(0)
      array_cells = convert_cells_to_array(game_state.cells)

      expect(array_cells).to eq ['X', nil, nil,
                                 nil, nil, nil,
                                 nil, nil, nil]
    end
  end
end

