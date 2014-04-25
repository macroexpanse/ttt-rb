require_relative '../lib/ttt'
require_relative '../lib/player'

ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
ttt = TTT.new(human_player, ai_player)

puts ttt.web_game(ARGV[0]).to_json
