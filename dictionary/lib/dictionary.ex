defmodule Dictionary do
  def random_word() do
    read_words()
    |> Enum.random()
  end

  def read_words() do
    "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/)
  end
end
