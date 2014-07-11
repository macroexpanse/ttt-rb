require './lib/command_line_interface'
require './lib/game_factory'
require './lib/command_line_game'

cli = CommandLineInterface.new
rules_factory = GameFactory.new
game = CommandLineGame.new(cli, rules_factory)

game.run
