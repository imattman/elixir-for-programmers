defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  #  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @spec interact(state) :: :ok

  def interact({_game, tally = %{game_state: :won}}) do
    IO.puts(~s/Congratulations! You guessed the word "#{tally.letters |> Enum.join()}"/)
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost. :-(")
    IO.puts(~s/The word was "#{tally.letters |> Enum.join()}"/)
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    updated_tally = Hangman.make_move(game, get_guess())
    interact({game, updated_tally})
  end

  defp feedback_for(tally = %{game_state: :initializing}) do
    "Welcome!  The challenge word has #{tally.letters |> length} letters."
  end

  defp feedback_for(%{game_state: :good_guess}), do: "Good guess!"
  defp feedback_for(%{game_state: :bad_guess}), do: "Sorry, that letter is not in the word."
  defp feedback_for(%{game_state: :already_used}), do: "You already used that letter."

  defp current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      "  turns left: ",
      tally.turns_left |> to_string(),
      "  letters used: ",
      tally.used |> Enum.join(", ")
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ") |> String.trim() |> String.downcase()
  end
end
