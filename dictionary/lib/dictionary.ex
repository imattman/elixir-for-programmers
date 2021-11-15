defmodule Dictionary do
  # build word list at compile time
  # stored in module attribute
  @word_list "assets/words.txt"
             |> File.read!()
             |> String.split(~r/\n/, trim: true)

  def random_word() do
    @word_list
    |> Enum.random()
  end
end
