require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'minimax_ai'


describe 'Command Line Game Service' do
  context '3x3 board' do
    let(:minimax_ai) { MinimaxAi.new }
    let(:game_state) { minimax_ai.generate('X', 'ai', 3) }
    let(:cli) { CommandLineInterface.new }
    let(:command_line_game) { CommandLineGame.new(minimax_ai, game_state, cli) }

    it 'initializes command line game with empty board' do
      cells = command_line_game.game_state.cells

      expect(cells.count).to eq 9
    end

    it 'ends game with farewell message if user does not want to play' do
      lambda { command_line_game.start_game('n') }.should raise_error(SystemExit) 
    end

    it 'ends game with game over message if player loss' do 
      STDOUT.should_receive(:puts).with("O|O|O\n | | \n | | \n Game over, you lose!")
      array_cells= ['O', 'O', 'O',
                     nil, nil, nil,
                     nil, nil, nil]
      
      cells = convert_array_to_minimax_cells(array_cells) 
      command_line_game.game_state.cells = cells
      command_line_game.game_over
     end

    it 'ends game with draw message if draw' do 
      STDOUT.should_receive(:puts).with("O|X|O\nX|X|O\nX|O|X\n The game ended in a draw")
      array_cells = ['O', 'X', 'O',
                     'X', 'X', 'O',
                     'X', 'O', 'X']
      cells = convert_array_to_minimax_cells(array_cells)
      command_line_game.game_state.cells = cells
      command_line_game.game_over
    end
  end
end
