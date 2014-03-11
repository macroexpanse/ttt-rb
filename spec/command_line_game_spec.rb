require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'minimax_ai'
require 'ttt'

describe 'Command Line Game Service' do
  context '3x3 board' do
    let(:minimax_ai) { MinimaxAi.new }
    let(:ai_player) { Player.new({:name => 'ai', :value => 'X'})}
    let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
    let(:game_state) { minimax_ai.generate_initial_game_state(ai_player, human_player, ai_player, 3) }
    let(:cli) { CommandLineInterface.new }

    let(:params) { {:interface=>"command line", :ai=>"minimax", :board_height=>3,
                  :first_player_name=>"ai", :human_value=>"X"} }

    let(:command_line_game) { CommandLineGame.new(minimax_ai, cli, ttt, ai_player, human_player) }

    let(:ttt) { TTT.new({:minimax_ai => minimax_ai, :human_player => human_player,
                         :ai_player => ai_player, :command_line_game => command_line_game }) }

    xit 'ends game with farewell message if user does not want to play' do
      command_line_game.instance_variable_set("@game_state", game_state)
      lambda { command_line_game.start_game('n') }.should raise_error(SystemExit) 
    end

    xit 'ends game with game over message if player loss' do 
      STDOUT.should_receive(:puts).with("O|O|O\n | | \n | | \n").and_call_original 
      STDOUT.should_receive(:puts).with(cli.class.const_get("LOSS"))
      array_cells= ['O', 'O', 'O',
                     nil, nil, nil,
                     nil, nil, nil]
      
      cells = convert_array_to_minimax_cells(array_cells) 
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      command_line_game.instance_variable_set("@game_state", game_state)
      command_line_game.game_over(params)
     end

    xit 'ends game with draw message if draw' do 
      STDOUT.should_receive(:puts).with("O|X|O\nX|X|O\nX|O|X\n").and_call_original
      STDOUT.should_receive(:puts).with(cli.class.const_get("DRAW")).and_call_original
      array_cells = ['O', 'X', 'O',
                     'X', 'X', 'O',
                     'X', 'O', 'X']
      cells = convert_array_to_minimax_cells(array_cells)
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      command_line_game.instance_variable_set("@game_state", game_state)
      command_line_game.game_over(params)
    end

    xit 'switches current player after ai move completes' do
      command_line_game.ai_move(params)   
      game_state = command_line_game.instance_variable_get("@game_state")
      current_player = game_state.instance_variable_get("@current_player")

      expect(current_player.name).to eq 'human' 
    end
   
    xit 'initializes default game state if game state is nil due to first human move' do
      command_line_game.initialize_default_game_state
      game_state = command_line_game.instance_variable_get("@game_state") 

       expect(game_state.class).to eq GameState
    end
  end
end
