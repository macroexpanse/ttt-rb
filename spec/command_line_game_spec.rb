require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'minimax_ai'
require 'ttt'


describe 'Command Line Game Service' do
  context '3x3 board' do
    let(:minimax_ai) { MinimaxAi.new }
    let(:ai_player) { Player.new({:name => 'ai', :value => 'X', :current_player => true})}
    let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
    let(:game_state) { minimax_ai.generate(ai_player, human_player, 3) }
    let(:cli) { CommandLineInterface.new }
    let(:ttt) { TTT.new }

    it 'ends game with farewell message if user does not want to play' do
      command_line_game =  CommandLineGame.new(minimax_ai, game_state, cli, ttt) 
      lambda { command_line_game.start_game('n') }.should raise_error(SystemExit) 
    end

    it 'ends game with game over message if player loss' do 
      STDOUT.should_receive(:puts).with("O|O|O\n | | \n | | \n").and_call_original 
      STDOUT.should_receive(:puts).with(cli.class::LOSS)
      array_cells= ['O', 'O', 'O',
                     nil, nil, nil,
                     nil, nil, nil]
      
      cells = convert_array_to_minimax_cells(array_cells) 
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      command_line_game = CommandLineGame.new(minimax_ai, game_state, cli, ttt)
      command_line_game.game_over
     end

    it 'ends game with draw message if draw' do 
      STDOUT.should_receive(:puts).with("O|X|O\nX|X|O\nX|O|X\n").and_call_original
      STDOUT.should_receive(:puts).with(cli.class::DRAW)
      array_cells = ['O', 'X', 'O',
                     'X', 'X', 'O',
                     'X', 'O', 'X']
      cells = convert_array_to_minimax_cells(array_cells)
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      command_line_game = CommandLineGame.new(minimax_ai, game_state, cli, ttt)
      command_line_game.game_over
    end
  end
end
