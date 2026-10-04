defmodule PasswordGenerator.CLI do
  @moduledoc """
  Точка входа для escript.
  """

  def main(args) do
    length =
      case args do
        [len_str] -> String.to_integer(len_str)
        _ -> 16
      end

    IO.puts(PasswordGenerator.generate(length))
  end
end
