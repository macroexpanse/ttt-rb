require_relative '../lib/command_line_game'
require_relative '../lib/command_line_interface'
require_relative '../lib/minimax_ai'
require_relative '../lib/game_state'
require_relative '../lib/ttt'
require_relative '../lib/player'


command_line_interface = CommandLineInterface.new
ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
game = CommandLineGame.new(command_line_interface, ai_player, human_player)

game.run



