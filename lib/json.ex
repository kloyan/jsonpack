defmodule Json do

    def pack(value) do
        case Poison.encode(value) do
            {:ok, json} -> json
            {:error, _} -> ""
        end
    end

    def unpack(json) do
        case Poison.decode(json) do
            {:ok, value} -> value
            {:error, _} -> %{}
        end
    end
end