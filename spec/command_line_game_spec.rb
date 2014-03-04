require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'minimax_ai'


describe 'Command Line Game Service' do
  context '3x3 board' do
    let(:minimax_ai) { MinimaxAi.new }
    let(:game_state) { minimax_ai.generate('X', 'ai', 3) }
    let(:command_line_game) { CommandLineGame.new(minimax_ai, game_state) }

    it 'initializes command line game with empty board' do
      cells = command_line_game.game_state.cells

      expect(cells.count).to eq 9
    end

    it 'ends game with farewell message if user does not want to play' do
      lambda { command_line_game.start_game('n') }.should raise_error(SystemExit) 
    end

    it 'ends game with game over message if final game state' do 
      STDOUT.should_receive(:puts).with("O|O|O\n |X| \n | | \n game over")
      array_cells = ['O', 'O', 'O',
                     nil, nil, nil,
                     nil, nil, nil]
      
      cells = convert_array_to_minimax_cells(array_cells) 
      command_line_game.game_state.cells = cells
      command_line_game.ai_move
     end
  end
end
