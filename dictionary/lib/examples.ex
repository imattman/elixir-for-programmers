defmodule Examples do

end

defmodule Sequence do
    def fib(0), do: 0
    def fib(1), do: 1
    def fib(n) do
      _fib(0, 1, n)
    end
  
    defp _fib(a, _, 0), do: a
    defp _fib(a, b, n) do
      _fib(b, a+b, n-1)
    end
  end

defmodule Lists do
    def map([], _func), do: []
    def map([h | t], func) do
        [func.(h) | map(t, func)]
    end
end
