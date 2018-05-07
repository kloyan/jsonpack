defmodule MessageUnpacker do
  @spec unpack(binary) :: any
  def unpack(x)

  # atoms
  def unpack(<<0xC0>>), do: nil
  def unpack(<<0xC2>>), do: false
  def unpack(<<0xC3>>), do: true

  # uint
  def unpack(<<0::1, x::7>>), do: x
  def unpack(<<0xCC, x::8>>), do: x
  def unpack(<<0xCD, x::16>>), do: x
  def unpack(<<0xCE, x::32>>), do: x
  def unpack(<<0xCF, x::64>>), do: x

  # float
  def unpack(<<0xCA, x::float>>), do: x

  # string
  def unpack(<<0b101::3, _::5, x::binary>>), do: x
  def unpack(<<0xD9, _::8, x::binary>>), do: x
  def unpack(<<0xDA, _::16, x::binary>>), do: x
  def unpack(<<0xDB, _::32, x::binary>>), do: x

  # binary
  def unpack(<<0xC4, _::8, x::binary>>), do: x
  def unpack(<<0xC5, _::16, x::binary>>), do: x
  def unpack(<<0xC6, _::32, x::binary>>), do: x

  # list
  def unpack(<<0b1001::4, _::4, x::binary>>), do: x
  def unpack(<<0xDC, _::16, x::binary>>), do: x
  def unpack(<<0xDD, _::32, x::binary>>), do: x

  # map
  def unpack(<<0b1000::4, _::4, x::binary>>), do: x
  def unpack(<<0xDE, _::16, x::binary>>), do: x
  def unpack(<<0xDF, _::32, x::binary>>), do: x

  # unrecognized binary
  def unpack(x), do: raise(ArgumentError, message: "unrecognized binary: #{x}")
end
