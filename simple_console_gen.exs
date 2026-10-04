defmodule PasswordGenerator do
  @moduledoc """
  Простой генератор паролей.
  """

  @doc """
  Генерирует пароль заданной длины из строчных латинских букв.
  """
  def generate(leng) when is_integer(leng) and leng > 0 do
    # возвращаем бинарник (последовательность байтов) заданной длины.
    :crypto.strong_rand_bytes(leng) |>
    # превращаем бинарник в список целых чисел
    :binary.bin_to_list() |>
    # превращаем каждый байт в код символа-буквы
    Enum.map(fn byte -> rem(byte, 26) + ?a end) |>
    # собираем список кодов символов в строку
    List.to_string()
  end
end

IO.puts(PasswordGenerator.generate(10))
