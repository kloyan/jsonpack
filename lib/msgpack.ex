defmodule MsgPack do

    @bit_5 32
    @bit_7 128
    @bit_8 256
    @bit_16 65536
    @bit_32 4294967296
    @bit_64 18446744073709551616

    defmacro is_valid_string(str) do
        quote do: String.valid?(unquote(str))
    end

    def pack(nil), do: << 0xC0 >>
    def pack(false), do: << 0xC2 >>
    def pack(true), do: << 0xC3 >>
    def pack(x) when is_integer(x), do: pack_uint(x)
    def pack(x) when is_float(x), do: << 0xCA, x::float >>
    def pack(x) when is_binary(x) do
        case String.valid?(x) do
            true -> pack_str(x)
            false -> pack_bin(x)
        end
    end

    defp pack_uint(x) when x < @bit_7, do: << 0::1, x::7 >>
    defp pack_uint(x) when x < @bit_8, do: << 0xCC, x::8 >>
    defp pack_uint(x) when x < @bit_16, do: << 0xCD, x::16 >>
    defp pack_uint(x) when x < @bit_32, do: << 0xCE, x::32 >>
    defp pack_uint(x) when x < @bit_64, do: << 0xCF, x::64 >>

    defp pack_str(x) when byte_size(x) < @bit_5, do: << 0b101::3, byte_size(x)::5, x::binary >>
    defp pack_str(x) when byte_size(x) < @bit_8, do: << 0xD9, byte_size(x)::8, x::binary >>
    defp pack_str(x) when byte_size(x) < @bit_16, do: << 0xDA, byte_size(x)::16, x::binary >>
    defp pack_str(x) when byte_size(x) < @bit_32, do: << 0xDB, byte_size(x)::32, x::binary >>

    defp pack_bin(x) when byte_size(x) < @bit_8, do: << 0xC4, byte_size(x)::8, x::binary >>
    defp pack_bin(x) when byte_size(x) < @bit_16, do: << 0xC5, byte_size(x)::16, x::binary >>
    defp pack_bin(x) when byte_size(x) < @bit_32, do: << 0xC6, byte_size(x)::32, x::binary >>
end