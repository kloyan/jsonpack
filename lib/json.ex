defmodule Json do
  def pack(value) do
    case Poison.encode(value) do
      {:ok, json} -> json
      {:error, _} -> raise ArgumentError, message: "invalid data provided"
    end
  end

  def unpack(json) do
    case Poison.decode(json) do
      {:ok, value} -> value
      {:error, _} -> raise ArgumentError, message: "invalid json provided"
    end
  end
end
