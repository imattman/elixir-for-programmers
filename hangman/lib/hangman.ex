defmodule Hangman do
  alias Hangman.Game

  defdelegate new_game(), to: Game

  defdelegate make_move(game, guess), to: Game

  defdelegate tally(game), to: Game

  # example of delegation with a different name.
  # notice the function is represented as an atom
  defdelegate funky(), to: Game, as: :new_game
end
