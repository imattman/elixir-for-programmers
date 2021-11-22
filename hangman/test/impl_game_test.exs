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

  test "lost game is detected" do
    game = Game.new_game("abc")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6

    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5

    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4

    {game, _tally} = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3

    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2

    {game, _tally} = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1

    {game, _tally} = Game.make_move(game, "g")
    assert game.game_state == :lost
  end
end
