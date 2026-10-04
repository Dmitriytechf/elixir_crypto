defmodule PasswordGenerator do
  @moduledoc """
  Генератор паролей с криптографически стойкой случайностью

  Использует `:crypto.strong_rand_bytes/1` — криптостойкий источник
  случайных байтов, и rejection sampling для устранения modulo bias
  """

  @lower "abcdefghijklmnopqrstuvwxyz"
  @upper "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  @digits "0123456789"
  @symbols "!@#$%^&*()-_=+[]{}"

  # Полный набор символов по умолчанию
  @charset @lower <> @upper <> @digits <> @symbols

  # Размер вычисляется один раз при компиляции
  @charset_size byte_size(@charset)

  # 2^32 — диапазон 32-битного беззнакового числа
  @uint32_range 0x1_0000_0000

  @doc """
  Генерирует пароль заданной длины из строчных латинских букв.
  """
  def generate(len) when is_integer(len) and len > 0 do
    1..len
    |> Enum.map(fn _ -> random_char() end)
    |> List.to_string()
  end

  # Генерирует один случайный символ из набора @charset
  #
  # Использует rejection sampling: берёт 4 случайных байта (32-битное число)
  # и отбрасывает значения, попадающие в "хвост" — те, что при делении
  # на @charset_size дали бы смещение в распределении
  #
  # Вероятность отбраковки меньше 0.000001%, поэтому рекурсия практически
  # никогда не случается
  defp  random_char do # приватная функция
    # берем 4 случайных байта
    value = :crypto.strong_rand_bytes(4) |> :binary.decode_unsigned()

    # Всё, что меньше limit, делится на charset_size без смещения
    lim = @uint32_range - rem(@uint32_range, @charset_size)

    if value < lim do
      :binary.at(@charset, rem(value, @charset_size))
    else
      random_char() # отбрасываем и пробуем снова
    end
  end
end


IO.inspect(PasswordGenerator.generate(15))
