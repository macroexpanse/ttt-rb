require_relative '../lib/command_line_game'
require_relative '../lib/command_line_interface'
require_relative '../lib/minimax_ai'
require_relative '../lib/game_state'
require_relative '../lib/ttt'
require_relative '../lib/player'


minimax_ai = MinimaxAi.new
command_line_interface = CommandLineInterface.new
ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
ttt = TTT.new(minimax_ai, human_player, ai_player)
game = CommandLineGame.new(minimax_ai, command_line_interface, ttt, ai_player, human_player)

game.run



