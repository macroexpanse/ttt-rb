require 'spec_helper'
require_relative '../ttt'
require 'command_line_interface'
require 'minimax_ai'

describe 'Command Line Interface Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:command_line_interface) { CommandLineInterface.new(minimax_ai) }
  let(:initial_game_state) { minimax_ai.generate('X', 3) } 

  it 'greets the user' do
    STDOUT.should_receive(:puts).with(CommandLineInterface::GREETING)

    command_line_interface.output_message(CommandLineInterface::GREETING)
  end   

  context "3x3 Board" do
    it 'draws board' do
      board = " | | \n | | \n | | \n" 
      STDOUT.should_receive(:puts).with(board)
      drawn_board = command_line_interface.draw_board(initial_game_state)
    end
  end
end
