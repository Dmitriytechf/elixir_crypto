defmodule PasswordGenerator do
  @moduledoc """
  Простой генератор паролей.
  """

  @doc """
  Генерирует пароль заданной длины из строчных латинских букв.
  """
  def generate(len) when is_integer(len) and len > 0 do
    # возвращаем бинарник (последовательность байтов) заданной длины.
    :crypto.strong_rand_bytes(len)
    # превращаем бинарник в список целых чисел
    |> :binary.bin_to_list()
    # превращаем каждый байт в код символа-буквы
    |> Enum.map(fn byte -> rem(byte, 26) + ?a end)
    # собираем список кодов символов в строку
    |> List.to_string()
  end
end

IO.inspect(PasswordGenerator.generate(15))

# статистика распределения букв
fre =
  1..1_000_000
  |> Enum.map(fn _ ->
    <<byte>> = :crypto.strong_rand_bytes(1)
    rem(byte, 26) + ?a
  end)
  |> Enum.frequencies()

IO.inspect(fre)
