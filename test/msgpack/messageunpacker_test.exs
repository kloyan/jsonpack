defmodule MessageUnpackerTest do
  use ExUnit.Case
  doctest MessageUnpacker

  test "correctly unpacks 'nil'" do
    assert MessageUnpacker.unpack(<<0xC0>>) == {nil, ""}
  end

  test "correctly unpacks 'true' and 'false'" do
    assert MessageUnpacker.unpack(<<0xC3>>) == {true, ""}
    assert MessageUnpacker.unpack(<<0xC2>>) == {false, ""}
  end

  test "correctly unpacks integers" do
    assert MessageUnpacker.unpack(<<0x7F>>) == {127, ""}
    assert MessageUnpacker.unpack(<<0xCC, 0xFF>>) == {255, ""}
    assert MessageUnpacker.unpack(<<0xCD, 0xFF, 0xFF>>) == {65_535, ""}
    assert MessageUnpacker.unpack(<<0xCE, 0xFF, 0xFF, 0xFF, 0xFF>>) == {4_294_967_295, ""}

    assert MessageUnpacker.unpack(<<0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>) ==
             {18_446_744_073_709_551_615, ""}
  end

  test "correctly unpacks strings" do
    assert MessageUnpacker.unpack(<<160>>) == {"", ""}
    assert MessageUnpacker.unpack(<<161, 32>>) == {" ", ""}
    assert MessageUnpacker.unpack(<<164, 116, 101, 115, 116>>) == {"test", ""}
  end

  test "correctly unpacks lists" do
    assert MessageUnpacker.unpack(<<144>>) == {[], ""}
    assert MessageUnpacker.unpack(<<148, 1, 2, 3, 4>>) == {Enum.to_list(1..4), ""}

    assert MessageUnpacker.unpack(<<148, 161, 116, 161, 101, 161, 115, 161, 116>>) ==
             {[
                "t",
                "e",
                "s",
                "t"
              ], ""}
  end

  test "correctly unpacks maps" do
    assert MessageUnpacker.unpack(<<128>>) == {%{}, ""}
    assert MessageUnpacker.unpack(<<130, 161, 97, 1, 161, 98, 2>>) == {%{"a" => 1, "b" => 2}, ""}
  end

  test "raise exception when invalid binary is provided" do
    assert_raise ArgumentError, fn -> MessageUnpacker.unpack(<<0xFF, 1, 2, 3>>) end
  end
end
