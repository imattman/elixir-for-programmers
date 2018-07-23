defmodule Hangman do

  alias Hangman.Game

#  def new_game() do
#    Game.new_game()
#  end

defdelegate new_game(), to: Game

end
