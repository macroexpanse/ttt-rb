require_relative '../lib/command_line_game'
require_relative '../lib/command_line_interface'
require_relative '../lib/minimax_ai'
require_relative '../lib/game_state'
require_relative '../lib/ttt'
require_relative '../lib/player'


ai = MinimaxAi.new
ttt = TTT.new
cli = CommandLineInterface.new
ai_player = Player.new({:name => 'ai', :value => 'O'})
human_player = Player.new({:name => 'human', :value => 'X'})
game = CommandLineGame.new(ai, cli, ttt, ai_player, human_player)

game.run



