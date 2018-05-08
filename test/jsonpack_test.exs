defmodule JsonPackTest do
  use ExUnit.Case
  doctest JsonPack

  @json "{\"schema\":0,\"compact\":true}"
  @msgpack <<130, 167, 99, 111, 109, 112, 97, 99, 116, 195, 166, 115, 99, 104, 101, 109, 97, 0>>

  test "correctly converts from json to msgpack" do
    assert JsonPack.json_to_msgpack(@json) == @msgpack
  end

  test "correctly converts from msgpack to json" do
    assert JsonPack.msgpack_to_json(@msgpack) == @json
  end

  test "convertion to json is performed with no data loss" do
    assert JsonPack.json_to_msgpack(JsonPack.msgpack_to_json(@msgpack)) == @msgpack
  end

  test "convertion to msgpack is performed with no data loss" do
    assert JsonPack.msgpack_to_json(JsonPack.json_to_msgpack(@json)) == @json
  end

  test "correctly converts empty json to empty msgpack" do
    assert JsonPack.json_to_msgpack("{}") == <<128>>
  end

  test "correctly converts empty msgpack to empty json" do
    assert JsonPack.msgpack_to_json(<<128>>) == "{}"
  end
end
