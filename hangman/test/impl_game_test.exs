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

  test "state doesn't change if game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game()
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "used letters are recorded" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")

    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "recognize letter that is in the word" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
  end

  test "recognize letter that is not in the word" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6

    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 6

    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
  end

  test "can handle a sequence of moves" do
    # table driven test for "hello"
    [
      # guess game_state turns_left  letters          used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["a", :already_used, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["o", :good_guess, 6, ["_", "e", "_", "_", "o"], ["a", "e", "o"]],
      ["s", :bad_guess, 5, ["_", "e", "_", "_", "o"], ["a", "e", "o", "s"]]
    ]
    |> test_sequence_of_move("hello")
  end

  test "winning game sequence" do
    # table driven test for "wibble"
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "_", "_", "_", "_", "e"], ["a", "e"]],
      ["s", :bad_guess, 5, ["_", "_", "_", "_", "_", "e"], ["a", "e", "s"]],
      ["w", :good_guess, 5, ["w", "_", "_", "_", "_", "e"], ["a", "e", "s", "w"]],
      ["b", :good_guess, 5, ["w", "_", "b", "b", "_", "e"], ["a", "b", "e", "s", "w"]],
      ["l", :good_guess, 5, ["w", "_", "b", "b", "l", "e"], ["a", "b", "e", "l", "s", "w"]],
      ["o", :bad_guess, 4, ["w", "_", "b", "b", "l", "e"], ["a", "b", "e", "l", "o", "s", "w"]],
      ["i", :won, 4, ["w", "i", "b", "b", "l", "e"], ["a", "b", "e", "i", "l", "o", "s", "w"]]
    ]
    |> test_sequence_of_move("wibble")
  end

  test "losing game sequence" do
    # table driven test for "cat"
    [
      ["a", :good_guess, 7, ["_", "a", "_"], ["a"]],
      ["b", :bad_guess, 6, ["_", "a", "_"], ["a", "b"]],
      ["x", :bad_guess, 5, ["_", "a", "_"], ["a", "b", "x"]],
      ["y", :bad_guess, 4, ["_", "a", "_"], ["a", "b", "x", "y"]],
      ["z", :bad_guess, 3, ["_", "a", "_"], ["a", "b", "x", "y", "z"]],
      ["e", :bad_guess, 2, ["_", "a", "_"], ["a", "b", "e", "x", "y", "z"]],
      ["b", :already_used, 2, ["_", "a", "_"], ["a", "b", "e", "x", "y", "z"]],
      ["s", :bad_guess, 1, ["_", "a", "_"], ["a", "b", "e", "s", "x", "y", "z"]],
      ["t", :good_guess, 1, ["_", "a", "t"], ["a", "b", "e", "s", "t", "x", "y", "z"]],
      ["p", :lost, 0, ["c", "a", "t"], ["a", "b", "e", "p", "s", "t", "x", "y", "z"]]
    ]
    |> test_sequence_of_move("cat")
  end

  defp test_sequence_of_move(tests, word) do
    game = Game.new_game(word)
    Enum.reduce(tests, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    # pass along game to next iteration
    game
  end
end
