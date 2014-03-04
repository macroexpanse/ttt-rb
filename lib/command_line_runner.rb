require_relative '../lib/command_line_game'
require_relative '../lib/command_line_interface'
require_relative '../lib/minimax_ai'
require_relative '../lib/game_state'

ai = MinimaxAi.new
game_state = ai.generate('O', 'human', 3)
game = CommandLineGame.new(ai, game_state)

game.run
