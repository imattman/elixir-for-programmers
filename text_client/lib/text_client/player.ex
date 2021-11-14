defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, State, Summary}

  # need handle
  # - won, lost, good guess, bad guess, already used, initializing
  def play(%State{game_service: gs, tally: %{game_state: :won}}) do
    word = Enum.join(gs.letters, "")
    exit_with_message("You won!\nYou correctly guessed '#{word}'")
  end

  def play(%State{game_service: gs, tally: %{game_state: :lost}}) do
    word = Enum.join(gs.letters, "")
    exit_with_message("Sorry, you lost :-(\nThe word was '#{word}'")
  end

  def play(game = %State{game_service: _gs, tally: %{game_state: :good_guess}}) do
    # word = Enum.join(gs.letters, "")
    # continue_with_message(game, "Good guess! [#{word}]")
    continue_with_message(game, "Good guess!")
  end

  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(game, "Sorry, that letter isn't in the word.")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "You've already used that letter.")
  end

  def play(game) do
    continue(game)
  end

  defp continue_with_message(game, msg) do
    IO.puts(msg)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
