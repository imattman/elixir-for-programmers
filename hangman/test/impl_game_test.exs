defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "game letters are lowercase a-z" do
    game = Game.new_game()

    # assert game.letters |> Enum.all?(fn c -> c =~ ~r/^[a-z]$/ end)
    assert game.letters |> Enum.all?(&(&1 =~ ~r/^[a-z]$/))
  end
end
