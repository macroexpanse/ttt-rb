require 'json'
require_relative '../lib/ttt'
require_relative '../lib/player'
require_relative '../lib/minimax_ai'
require_relative '../lib/ai'

ai_player = Player.new({:name => 'ai'})
human_player = Player.new({:name => 'human'})
ttt = TTT.new(ai_player, human_player) 

params = {"cell0"=>"{\"id\":0,\"position\":\"a1\",\"value\":\"X\"}",
          "cell1"=>"{\"id\":1,\"position\":\"a2\",\"value\":null}",
          "cell2"=>"{\"id\":2,\"position\":\"a3\",\"value\":null}",
          "cell3"=>"{\"id\":3,\"position\":\"b1\",\"value\":null}",
          "cell4"=>"{\"id\":4,\"position\":\"b2\",\"value\":null}",
          "cell5"=>"{\"id\":5,\"position\":\"b3\",\"value\":null}",
          "cell6"=>"{\"id\":6,\"position\":\"c1\",\"value\":null}",
          "cell7"=>"{\"id\":7,\"position\":\"c2\",\"value\":null}",
          "cell8"=>"{\"id\":8,\"position\":\"c3\",\"value\":null}",
          :human_value =>"X",
          :turn =>"1", :ai => "minimax"}
           
puts ttt.sinatra_game(params).to_json







