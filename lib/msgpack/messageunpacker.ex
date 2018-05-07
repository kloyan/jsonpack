defmodule MessageUnpacker do
  @spec unpack(binary) :: {any, binary}
  def unpack(x)

  # atoms
  def unpack(<<0xC0, rest::binary>>), do: {nil, rest}
  def unpack(<<0xC2, rest::binary>>), do: {false, rest}
  def unpack(<<0xC3, rest::binary>>), do: {true, rest}

  # uint
  def unpack(<<0::1, x::7, rest::binary>>), do: {x, rest}
  def unpack(<<0xCC, x::8, rest::binary>>), do: {x, rest}
  def unpack(<<0xCD, x::16, rest::binary>>), do: {x, rest}
  def unpack(<<0xCE, x::32, rest::binary>>), do: {x, rest}
  def unpack(<<0xCF, x::64, rest::binary>>), do: {x, rest}

  # string
  def unpack(<<0b101::3, sz::5, x::binary-size(sz), rest::binary>>), do: {x, rest}
  def unpack(<<0xD9, sz::8, x::binary-size(sz), rest::binary>>), do: {x, rest}
  def unpack(<<0xDA, sz::16, x::binary-size(sz), rest::binary>>), do: {x, rest}
  def unpack(<<0xDB, sz::32, x::binary-size(sz), rest::binary>>), do: {x, rest}

  # binary
  def unpack(<<0xC4, sz::8, x::binary-size(sz), rest::binary>>), do: {x, rest}
  def unpack(<<0xC5, sz::16, x::binary-size(sz), rest::binary>>), do: {x, rest}
  def unpack(<<0xC6, sz::32, x::binary-size(sz), rest::binary>>), do: {x, rest}

  # list
  def unpack(<<0b1001::4, sz::4, x::binary>>), do: unpack_list(x, sz)
  def unpack(<<0xDC, sz::16, x::binary>>), do: unpack_list(x, sz)
  def unpack(<<0xDD, sz::32, x::binary>>), do: unpack_list(x, sz)

  # map
  def unpack(<<0b1000::4, sz::4, x::binary>>), do: unpack_map(x, sz)
  def unpack(<<0xDE, sz::16, x::binary>>), do: unpack_map(x, sz)
  def unpack(<<0xDF, sz::32, x::binary>>), do: unpack_map(x, sz)

  # unrecognized binary
  def unpack(x), do: raise(ArgumentError, message: "unrecognized binary: #{x}")

  # list helper functions
  defp unpack_list(bin, size), do: unpack_list(bin, size, [])
  defp unpack_list(bin, 0, lst), do: {lst, bin}

  defp unpack_list(bin, size, lst) do
    {val, rest} = unpack(bin)
    unpack_list(rest, size - 1, lst ++ [val])
  end

  # map helper functions
  defp unpack_map(bin, size), do: unpack_map(bin, size, %{})
  defp unpack_map(bin, 0, map), do: {map, bin}

  defp unpack_map(bin, size, map) do
    {key, rest} = unpack(bin)
    {val, rest} = unpack(rest)

    unpack_map(rest, size - 1, Map.put(map, key, val))
  end
end
