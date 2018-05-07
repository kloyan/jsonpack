defmodule MsgPack do
  @spec pack(any) :: binary
  def pack(data), do: MessagePacker.pack(data)

  @spec unpack(binary) :: any
  def unpack(data), do: MessageUnpacker.unpack(data)
end
