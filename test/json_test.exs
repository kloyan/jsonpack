defmodule JsonTest do
    use ExUnit.Case
    doctest Json

    test "correctly packs empty data" do
        assert Json.pack(%{}) == "{}"
    end
    
    test "correctly packs data" do
        assert Json.pack(%{"a" => 1, "b" => 2}) == "{\"b\":2,\"a\":1}"
    end

    test "correctly unpacks empty json" do
        assert Json.unpack("{}") == %{}
    end

    test "correctly unpacks json with data" do
        assert Json.unpack("{\"b\":2,\"a\":1}") == %{"a" => 1, "b" => 2}
    end

    test "raise exception when empty string is provided" do
        assert_raise ArgumentError, fn -> Json.unpack("") end
    end

    test "raise exception when json with invalid syntax is provided" do
        assert_raise ArgumentError, fn -> Json.unpack("{\"b\":2,\"a\":}") end
    end
end