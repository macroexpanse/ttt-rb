require_relative '../lib/ttt'
require_relative '../lib/player'
require_relative '../lib/minimax_ai'
require_relative '../lib/ai'

ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
ttt = TTT.new(ai_player, human_player) 
           
puts ttt.sinatra_game(ARGV[0]).to_json







