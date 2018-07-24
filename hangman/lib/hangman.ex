defmodule Hangman do

  alias Hangman.Game

#  def new_game() do
#    Game.new_game()
#  end

  defdelegate new_game(),             to: Game
  defdelegate tally(game),            to: Game

  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    { game, tally(game) }
  end
  
end