defmodule MsgPack do
  @bit_4 16
  @bit_5 32
  @bit_7 128
  @bit_8 256
  @bit_16 65536
  @bit_32 4_294_967_296
  @bit_64 18_446_744_073_709_551_616

  defmacro is_valid_string(str) do
    quote do: String.valid?(unquote(str))
  end

  def pack(nil), do: <<0xC0>>
  def pack(false), do: <<0xC2>>
  def pack(true), do: <<0xC3>>
  def pack(x) when is_atom(x), do: pack(Atom.to_string(x))
  def pack(x) when is_integer(x), do: pack_uint(x)
  def pack(x) when is_float(x), do: <<0xCA, x::float>>

  def pack(x) when is_binary(x) do
    case String.valid?(x) do
      true -> pack_str(x)
      false -> pack_bin(x)
    end
  end

  def pack(x) when is_list(x), do: pack_list(x)
  def pack(x) when is_map(x), do: pack_map(x)

  defp pack_uint(x) when x < @bit_7, do: <<0::1, x::7>>
  defp pack_uint(x) when x < @bit_8, do: <<0xCC, x::8>>
  defp pack_uint(x) when x < @bit_16, do: <<0xCD, x::16>>
  defp pack_uint(x) when x < @bit_32, do: <<0xCE, x::32>>
  defp pack_uint(x) when x < @bit_64, do: <<0xCF, x::64>>

  defp pack_str(x) when byte_size(x) < @bit_5, do: <<0b101::3, byte_size(x)::5, x::binary>>
  defp pack_str(x) when byte_size(x) < @bit_8, do: <<0xD9, byte_size(x)::8, x::binary>>
  defp pack_str(x) when byte_size(x) < @bit_16, do: <<0xDA, byte_size(x)::16, x::binary>>
  defp pack_str(x) when byte_size(x) < @bit_32, do: <<0xDB, byte_size(x)::32, x::binary>>

  defp pack_bin(x) when byte_size(x) < @bit_8, do: <<0xC4, byte_size(x)::8, x::binary>>
  defp pack_bin(x) when byte_size(x) < @bit_16, do: <<0xC5, byte_size(x)::16, x::binary>>
  defp pack_bin(x) when byte_size(x) < @bit_32, do: <<0xC6, byte_size(x)::32, x::binary>>

  defp pack_list(x) when length(x) < @bit_4,
    do: <<0b1001::4, length(x)::4, pack_list(x, <<>>)::binary>>

  defp pack_list(x) when length(x) < @bit_16,
    do: <<0xDC, length(x)::16, pack_list(x, <<>>)::binary>>

  defp pack_list(x) when length(x) < @bit_32,
    do: <<0xDD, length(x)::32, pack_list(x, <<>>)::binary>>

  defp pack_list([], acc), do: acc
  defp pack_list([head | tail], acc), do: pack_list(tail, <<acc::binary, pack(head)::binary>>)

  defp pack_map(x) when map_size(x) < @bit_4 do
    <<0b1000::4, map_size(x)::4, pack_map(Map.to_list(x), <<>>)::binary>>
  end

  defp pack_map(x) when map_size(x) < @bit_16 do
    <<0xDE, map_size(x)::16, pack_map(Map.to_list(x), <<>>)::binary>>
  end

  defp pack_map(x) when map_size(x) < @bit_32 do
    <<0xDF, map_size(x)::32, pack_map(Map.to_list(x), <<>>)::binary>>
  end

  defp pack_map([], acc), do: acc

  defp pack_map([{key, value} | tail], acc) do
    pack_map(tail, <<acc::binary, pack(key)::binary, pack(value)::binary>>)
  end
end
