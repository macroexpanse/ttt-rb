require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'minimax_ai'
require 'game_state'


describe 'Command Line Game Service' do
  context '3x3 board' do
    let(:minimax_ai) { MinimaxAi.new }
    let(:game_state) { minimax_ai.generate('X', 3) }
    let(:command_line_game) { CommandLineGame.new(minimax_ai, game_state) }

    it 'initializes command line game with empty board' do
      cells = command_line_game.game_state.cells

      expect(cells.count).to eq 9
    end

   #it 'draws board if user wants to play' do
     # board = " | | \n | | \n | | \n"
     # STDOUT.should_receive(:puts).with(board)

      # command_line_game.start_game('y')
    # end

    it 'ends game with farewell message if user does not want to play' do
      lambda { command_line_game.start_game('n') }.should raise_error(SystemExit) 
    end
  
  end
end
