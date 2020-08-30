defmodule Dictionary do
  def word_list do
    contents = File.read!("assets/words.txt")
    list = String.split(contents, ~r/\n/)
  end
  def hello do
    IO.puts "This is so freaking cool!"
  end
end
