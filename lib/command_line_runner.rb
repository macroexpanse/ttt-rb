require './lib/command_line_game'
require './lib/command_line_interface'

cli = CommandLineInterface.new
game = CommandLineGame.new(cli)

game.run
