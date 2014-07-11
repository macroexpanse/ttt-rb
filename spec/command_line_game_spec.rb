require 'spec_helper'
require 'command_line_game'
require 'command_line_interface'
require 'game_factory'

describe CommandLineGame do
  context '3x3 board' do
    let(:cli) { CommandLineInterface.new }
    let(:game_factory) { GameFactory.new }
    let(:clg) { described_class.new(cli, game_factory) }

    before :each do
      allow(cli).to receive(:get_ai_type)           { "minimax" }
      allow(cli).to receive(:get_board_height)      { 3 }
      allow(cli).to receive(:get_first_player_name) { "ai" }
      allow(cli).to receive(:get_human_value)       { "X" }
      allow(cli).to receive(:play_again_prompt)     { "n" }
    end

    it 'ends game with farewell message if user does not want to play' do
      lambda { clg.start_game('n') }.should raise_error(SystemExit)
    end

    it 'calls human move first if player wants to go first' do
      allow(cli).to receive(:get_first_player_name) { "human" }
      allow(clg).to receive(:human_move)
      allow(clg).to receive(:ai_move)
      clg.start_game("y")
      expect(clg).to have_received(:human_move)
      expect(clg).not_to have_received(:ai_move)
    end

    it 'calls ai move first if player wants to go first' do
      allow(cli).to receive(:get_first_player_name) { "ai" }
      allow(clg).to receive(:human_move)
      allow(clg).to receive(:ai_move)
      clg.start_game("y")
      expect(clg).to have_received(:ai_move)
      expect(clg).not_to have_received(:human_move)
    end

    it 'ends game with game over message if player loss' do
      allow(clg).to receive(:game_over?) { true }
      allow(clg).to receive(:draw?) { false }
      allow(cli).to receive(:player_loss_response)
      lambda { clg.start_game("y") }.should raise_error(SystemExit)
      expect(cli).to have_received(:player_loss_response)
    end

    it 'ends game with draw message if draw' do
      allow(clg).to receive(:game_over?) { true }
      allow(clg).to receive(:draw?) { true }
      allow(cli).to receive(:draw_response)
      lambda { clg.start_game("y") }.should raise_error(SystemExit)
      expect(cli).to have_received(:draw_response)
    end

    it 'calls change game options if the player wishes to play again' do
      allow(clg).to receive(:game_over?) { true }
      allow(clg).to receive(:draw?) { false }
      allow(cli).to receive(:play_again_prompt) { "y" }
      allow(clg).to receive(:change_game_options)
      clg.start_game("y")
      expect(clg).to have_received(:change_game_options)
    end

    it "starts new game with old options if player does not wish to change them" do
      allow(clg).to receive(:game_over?) { true }
      allow(clg).to receive(:draw?) { false }
      allow(cli).to receive(:play_again_prompt) { "y" }
      allow(cli).to receive(:change_options_prompt) { "n" }
      allow(clg).to receive(:new_game)
      clg.start_game("y")
      expect(clg).to have_received(:new_game)
    end
  end
end
