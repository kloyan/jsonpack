defmodule MessagePackerTest do
  use ExUnit.Case
  doctest MessagePacker

  test "correctly packs 'nil'" do
    assert MessagePacker.pack(nil) == <<0xC0>>
  end

  test "correctly packs 'true' and 'false'" do
    assert MessagePacker.pack(true) == <<0xC3>>
    assert MessagePacker.pack(false) == <<0xC2>>
  end

  test "correctly packs atoms as strings" do
    msgpack_value = <<171, 104, 101, 108, 108, 111, 95, 119, 111, 114, 108, 100>>

    assert MessagePacker.pack(:hello_world) == msgpack_value
    assert MessagePacker.pack("hello_world") == msgpack_value
  end

  test "correctly packs integers" do
    assert MessagePacker.pack(127) == <<0x7F>>
    assert MessagePacker.pack(255) == <<0xCC, 0xFF>>
    assert MessagePacker.pack(65_535) == <<0xCD, 0xFF, 0xFF>>
    assert MessagePacker.pack(4_294_967_295) == <<0xCE, 0xFF, 0xFF, 0xFF, 0xFF>>

    assert MessagePacker.pack(18_446_744_073_709_551_615) ==
             <<0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>
  end

  test "raise exception when invalid integer is provided" do
    assert_raise ArgumentError, fn -> MessagePacker.pack(18_446_744_073_709_551_616) end
    assert_raise ArgumentError, fn -> MessagePacker.pack(-10) end
  end

  test "correctly packs strings" do
    assert MessagePacker.pack("") == <<160>>
    assert MessagePacker.pack(" ") == <<161, 32>>
    assert MessagePacker.pack("test") == <<164, 116, 101, 115, 116>>
  end

  test "correctly packs lists" do
    assert MessagePacker.pack([]) == <<144>>
    assert MessagePacker.pack(Enum.to_list(1..4)) == <<148, 1, 2, 3, 4>>

    assert MessagePacker.pack(["t", "e", "s", "t"]) ==
             <<148, 161, 116, 161, 101, 161, 115, 161, 116>>
  end

  test "correctly packs maps" do
    assert MessagePacker.pack(%{}) == <<128>>
    assert MessagePacker.pack(%{"a" => 1, "b" => 2}) == <<130, 161, 97, 1, 161, 98, 2>>
  end
end
