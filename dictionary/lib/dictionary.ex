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

  def swap({a, b}) do
    {b, a}
  end

  def same({a, a}) do
    true
  end

  def same({_a, _b}) do
    false
  end
end
