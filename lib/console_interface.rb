class ConsoleInterface

  def initialize(ai)
    @ai = ai
  end

  def greeting(user_input = gets.chomp.downcase)
    "Welcome to ttt-rb, are you ready to play?"
    run(user_input)
  end

  def run(user_input)
    user_input == 'y' ? initialize_console_game : kill
  end

  def initialize_console_game
    @ai.generate('X', 9)
  end

end
