defmodule Hangman do
  alias Hangman.Game

  defdelegate new_game(), to: Game
  defdelegate tally(game), to: Game

  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    {game, tally(game)}
  end

  # example of delegation with a different name.
  # notice the function is represented as an atom
  defdelegate funky(), to: Game, as: :new_game
end
