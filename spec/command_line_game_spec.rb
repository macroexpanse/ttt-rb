require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'minimax_ai'
require 'player'
require 'ttt'

describe 'Command Line Game Service' do
  context '3x3 board' do
    let(:cells) { Cell.generate_default_cells(3) } 
    let(:game_state) { GameState.new(ai_player, human_player, ai_player, cells, 1) }
    let(:minimax_ai) { MinimaxAi.new(game_state) }
    let(:ai_player) { Player.new({:name => 'ai', :value => 'X'})}
    let(:human_player) { Player.new({:name => 'human', :value => 'O'}) }
    let(:cli) { CommandLineInterface.new }
    let(:params) { {"interface" => "command line", "ai"=>"minimax", "turn" => 4, "board_height" => 3, "first_player_name"=>"ai", "human_value"=>"X"} }
    let(:ttt) { TTT.new(human_player, ai_player) }
    let(:clg) { clg = CommandLineGame.new(minimax_ai, cli, ttt, ai_player, human_player) } 

    it 'ends game with farewell message if user does not want to play' do
      clg.instance_variable_set("@game_state", game_state)
      lambda { clg.start_game('n') }.should raise_error(SystemExit) 
    end

    it 'ends game with game over message if player loss' do 
      clg.instance_variable_set("@params", params)
      allow(cli).to receive(:player_loss_response)
      allow(clg).to receive(:play_again) 
      array_cells = ['O', 'O', nil,
                     nil, nil, "X",
                     "X", nil, nil]
      cells = convert_array_to_minimax_cells(array_cells) 
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      clg.instance_variable_set("@game_state", game_state)
      clg.first_turn
      expect(cli).to have_received(:player_loss_response)
     end

    it 'ends game with draw message if draw' do 
      allow(cli).to receive(:draw_response)
      allow(clg).to receive(:play_again)
      array_cells = ['O', 'X', 'O',
                     'X', 'X', 'O',
                     'X', 'O', "X"]

      cells = convert_array_to_minimax_cells(array_cells)
      game_state = GameState.new(ai_player, human_player, ai_player, cells, 2)
      clg.instance_variable_set("@game_state", game_state)
      clg.instance_variable_set("@params", params)
      clg.game_over
      expect(cli).to have_received(:draw_response)
    end

    it 'switches current player after ai move completes' do
      allow(cli).to receive(:start_human_move)
      allow(clg).to receive(:human_move)
      clg.instance_variable_set("@params", params)
      clg.instance_variable_set("@game_state", game_state)
      clg.ai_move   
      game_state = clg.instance_variable_get("@game_state")
      current_player = game_state.instance_variable_get("@current_player")

      expect(current_player.name).to eq 'human' 
    end
   
    it 'initializes default game state if game state is nil due to first human move' do
      clg.instance_variable_set("@params", params)
      clg.initialize_default_game_state
      game_state = clg.instance_variable_get("@game_state") 

       expect(game_state.class).to eq GameState
    end
  end
end
