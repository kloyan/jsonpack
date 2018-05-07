defmodule MsgPack do
  @spec pack(any) :: binary
  def pack(data), do: MessagePacker.pack(data)

  @spec unpack(binary) :: any
  def unpack(bin), do: MessageUnpacker.unpack(bin) |> validate_unpacked

  defp validate_unpacked({data, ""}), do: data
  defp validate_unpacked(_), do: raise(ArgumentError, message: "incomplete binary")
end
