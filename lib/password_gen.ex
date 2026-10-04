defmodule PasswordGenerator do
  @moduledoc """
  Генератор паролей с криптографически стойкой случайностью
  """
  @lower "abcdefghijklmnopqrstuvwxyz"
  @upper "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  @digits "0123456789"

  @charset @lower <> @upper <> @digits
  @charset_size byte_size(@charset)
  @uint32_range 0x1_0000_0000
  @doc """
  Генерирует пароль заданной длины
  """
  def generate(len) when is_integer(len) and len > 0 do
    1..len
    |> Enum.map(fn _ -> random_char() end)
    |> List.to_string()
  end

  defp random_char do
    value = :crypto.strong_rand_bytes(4) |> :binary.decode_unsigned()
    limit = @uint32_range - rem(@uint32_range, @charset_size)

    if value < limit do
      :binary.at(@charset, rem(value, @charset_size))
    else
      random_char()
    end
  end
end
