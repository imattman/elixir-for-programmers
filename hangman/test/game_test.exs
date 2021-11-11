defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0

    # verify all letters fall in expected range
    assert game.letters |> Enum.all?(fn c -> c =~ ~r/[a-z]/ end)
  end

  test "game state isn't changed for :won game" do
    game = Game.new_game() |> Map.put(:game_state, :won)

    # one way
    # {new_game, _} = Game.make_move(game, "x")
    # assert new_game == game

    # other way using pinned match
    assert {^game, _} = Game.make_move(game, "x")
  end

  test "game state isn't changed for :lost game" do
    game = Game.new_game() |> Map.put(:game_state, :lost)
    assert {^game, _} = Game.make_move(game, "x")
  end
end
