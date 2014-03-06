require_relative '../lib/command_line_game'
require_relative '../lib/command_line_interface'
require_relative '../lib/minimax_ai'
require_relative '../lib/game_state'
require_relative '../lib/ttt'


def setup_game
  ai = MinimaxAi.new
  ai_player = Player.new({:name => 'ai', :value => 'X'})
  human_player = Player.new({:name => 'human', :value => 'O'})
  game_state = ai.generate(ai_player, human_player, human_player, 3)
  ttt = TTT.new
  cli = CommandLineInterface.new
  game = CommandLineGame.new(ai, game_state, cli, ttt)
end

playing = true

while playing do
  cli = CommandLineInterface.new
  setup_game.run  
  cli.output_message("PLAY_AGAIN")
  user_input = cli.accept_input
  if user_input == 'n' || user_input == 'no'
    playing = false  
    cli.output_message("FAREWELL")
  end
end





