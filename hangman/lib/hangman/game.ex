defmodule Hangman.Game do
  # one struct allowed per module
  # it's name is the same as the module
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  def new_game() do
    new_game(Dictionary.random_word())
  end

  def make_move(game = %{game_state: :won}, _guess) do
    {game, tally(game)}
  end

  def make_move(game = %{game_state: :lost}, _guess) do
    {game, tally(game)}
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    {game, tally(game)}
  end

  def accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won()

    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game, _not_good_guess) do
    game
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp tally(_game) do
    123
  end
end
