defmodule TextClient.Prompter do
  alias TextClient.State

  def accept_move(game = %State{}) do
    IO.gets("Your next guess: ")
    |> check_input(game)
  end

  defp check_input({:error, reason}, _) do
    IO.puts("Game ended: #{reason}")
    exit(:normal)
  end

  defp check_input(:eof, _) do
    IO.puts("Looks like you gave up...")
    exit(:normal)
  end

  defp check_input(input, game = %State{}) do
    input = String.trim(input)

    cond do
      # input =~ ~r/\A[a-z]\z/ ->
      input =~ ~r/^[a-z]$/ ->
        # return new game state
        Map.put(game, :guess, input)

      # anything else
      true ->
        IO.puts("Please enter a single lowercase letter.")
        # prompt again using the current game state
        accept_move(game)
    end
  end
end
