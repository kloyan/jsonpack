defmodule JsonPack do
  @spec json_to_msgpack(String.t()) :: binary
  def json_to_msgpack(json) do
    json
    |> Json.unpack()
    |> MsgPack.pack()
  end

  @spec msgpack_to_json(binary) :: String.t()
  def msgpack_to_json(msgpack) do
    msgpack
    |> MsgPack.unpack()
    |> Json.pack()
  end

  @spec to_msgpack(any) :: binary
  def to_msgpack(data) do
    data
    |> MsgPack.pack()
  end

  @spec to_json(any) :: String.t()
  def to_json(data) do
    data
    |> Json.pack()
  end
end
