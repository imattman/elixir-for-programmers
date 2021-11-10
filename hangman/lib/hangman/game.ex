defmodule Hangman.Game do

  # one struct allowed per module
  # it's name is the same as the module
  defstruct(
      turns_left: 7,
      game_state: :initializing,
      letters: [],

  )

  def new_game() do
    %Hangman.Game{
      letters: Dictionary.random_word |> String.codepoints
      }
  end

end
