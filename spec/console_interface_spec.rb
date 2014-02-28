require 'spec_helper'
require_relative '../ttt'
require 'console_interface'
require 'minimax_ai'

describe 'Console Interface Service' do
  let(:minimax_ai) { MinimaxAi.new }
  let(:console_interface) { ConsoleInterface.new(minimax_ai) }

  it 'initializes game if user is ready to play' do
    user_input = 'y'
    game_state = console_interface.greeting(user_input)
    expect(game_state.class).to eq GameState 
  end

end
