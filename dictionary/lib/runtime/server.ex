defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList

  use Agent

  @type t :: pid()

  @me __MODULE__

  def start_link(_args) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  def random_word() do
    if :rand.uniform() < 0.333 do
      # periodically crash the Agent to demonstrate supervision
      Agent.get(@me, fn _ -> exit(:kaboom) end)
    end

    Agent.get(@me, &WordList.random_word/1)
  end
end
