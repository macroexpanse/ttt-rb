require './lib/command_line_interface'
require './lib/game_factory'
require './lib/command_line_game'

cli = CommandLineInterface.new
game_factory = GameFactory.new
game = CommandLineGame.new(cli, game_factory)

game.run
