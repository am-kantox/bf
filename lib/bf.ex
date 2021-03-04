defmodule Bf do
  @moduledoc """
  Documentation for `Bf`.
  """

  use Boundary

  @mapping %{
    ?< => "🐱",
    ?] => "😹",
    ?> => "😼",
    ?[ => "😸",
    ?, => "😽",
    ?- => "😾",
    ?. => "😻",
    ?+ => "😺"
  }
  @symbols Map.keys(@mapping)
  @reverse for {k, v} <- @mapping, into: %{}, do: {v, k}

  @doc "Maps standard brainfuck to lovekitty"
  @spec map(bitstring(), map()) :: bitstring()
  def map(input, mapping \\ @mapping) do
    allowed = Map.keys(mapping)
    for <<c <- input>>, c in allowed, into: "", do: mapping[c]
  end

  @doc "Maps lovekitty to standard brainfuck"
  @spec unmap(binary(), map()) :: binary()
  def unmap(input, mapping \\ @reverse) do
    input
    |> String.graphemes()
    |> Enum.map(&Map.get(mapping, &1))
    |> Enum.reject(&is_nil/1)
    |> to_string()
  end

  @spec run(binary(), :bf | :kitty) :: :ok
  def run(input, dialect \\ :bf) do
    input =
      if File.exists?(input),
        do: File.read!(input),
        else: input

    input =
      if dialect == :kitty,
        do: unmap(input),
        else: input

    process(input, %{pos: 0, levels: [], skip: false})
  end

  defp process("", %{pos: _pos}), do: IO.puts("")

  # defp process(<<?], rest::binary>>, %{skip: true, levels: []} = acc),
  #   do: process(rest, %{acc | skip: false})

  defp process(<<?], rest::binary>>, %{skip: true, levels: [_ | t]} = acc),
    do: process(rest, %{acc | skip: false, levels: t})

  defp process(<<_::8, rest::binary>>, %{skip: true} = acc),
    do: process(rest, acc)

  defp process(<<?], rest::binary>> = input, %{pos: pos, levels: [h | t]} = acc) do
    ensure_dyno(pos)
    {:ok, value} = Bf.Dyno.synch_call(pos, :<)

    if value > 0,
      do: process(h <> input, %{acc | levels: t}),
      else: process(rest, %{acc | levels: Enum.map(t, &(&1 <> h <> "]"))})
  end

  defp process(<<?[, rest::binary>>, %{pos: pos, levels: levels} = acc) do
    ensure_dyno(pos)
    {:ok, value} = Bf.Dyno.synch_call(pos, :<)

    if value > 0,
      do: process(rest, %{acc | levels: ["[" | levels]}),
      else: process(rest, %{acc | skip: true})
  end

  defp process(<<sym::8, rest::binary>>, acc) when not (sym in @symbols),
    do: process(rest, acc)

  defp process(<<?>, rest::binary>>, %{pos: pos, levels: levels} = acc),
    do: process(rest, %{acc | pos: pos + 1, levels: update_levels(levels, ">")})

  defp process(<<?<, rest::binary>>, %{pos: pos, levels: levels} = acc),
    do: process(rest, %{acc | pos: pos - 1, levels: update_levels(levels, "<")})

  defp process(<<?+, rest::binary>>, %{pos: pos, levels: levels} = acc) do
    ensure_dyno(pos)
    Bf.Dyno.asynch_call(pos, :+)
    process(rest, %{acc | levels: update_levels(levels, "+")})
  end

  defp process(<<?-, rest::binary>>, %{pos: pos, levels: levels} = acc) do
    ensure_dyno(pos)
    Bf.Dyno.asynch_call(pos, :-)
    process(rest, %{acc | levels: update_levels(levels, "-")})
  end

  defp process(<<?., rest::binary>>, %{pos: pos, levels: levels} = acc) do
    ensure_dyno(pos)
    {:ok, value} = Bf.Dyno.synch_call(pos, :<)
    IO.write(<<value>>)
    process(rest, %{acc | levels: update_levels(levels, ".")})
  end

  defp process(<<?,, rest::binary>>, %{pos: pos, levels: levels} = acc) do
    ensure_dyno(pos)
    [value] = "" |> IO.getn() |> to_charlist()
    Bf.Dyno.asynch_call(pos, {:>, value})
    process(rest, %{acc | levels: update_levels(levels, ",")})
  end

  defp ensure_dyno(pos) do
    if %{} == Bf.Dyno.get(pos) do
      Bf.Dyno.put(pos, payload: 0, timeout: 0)
      Process.sleep(100)
    end
  end

  defp update_levels([], _), do: []
  defp update_levels([h | t], sym), do: [h <> sym | t]
end
