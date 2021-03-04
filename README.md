# 😻 :: Brainfuck dialect with ❤

## Example (hello ~~world~~ kitty)

```elixir
Bf.run(
  """
  😺😺😺😺 😺😺😺😺
  😸😼😺😺😺😺 😸😼😺😺😼😺😺😺😼😺😺😺😼😺🐱🐱🐱🐱😾😹 😼😺😼😺😼😾😼😼😺 😸🐱😹 🐱😾😹
  😼😼😺😺😺😺😺😻😼😾😾😾😻😺😺😺😺😺😺😺😺😺😺😻😺😺😺😺😺😺😺😺😻
  """
)
#⇒ "Meow"
```

## Reasoning

This is a tutorial project with zero production value. I was poking around providing a good example for `Tarearbol.DynamicManager` usecases, and stumbled upon [`Brainfuck`](https://en.wikipedia.org/wiki/Brainfuck).

Several years ago I attended Joe Armstrong’s talk where he was playing music with scheduled erlang processes, one per a note, with the proper intervals and tone. It was amazing, although not very practical.

Well, since I am after showing the advantages of the library, I decided to steal the Joe’s idea and use processes as data cells. I understand circumstances and I am not going to benchmark this solution against pure `c` implementation with a random memory access. This is just an example.

## Syntax

I found tiresome implementing a `Brainfuck` as it is, so I introduced a brand new welcoming syntax.

Here is a correspondence table between `Brainfuck` instructions, 😻 instructions and old good `c`.

brainfuck | 😻 | command C equivalent
--------- | -- | --------------------
‹Start› | ‹Start› | `char array[30000] = {0}; char *ptr = &array[0];`
`>` | 😼 | `++ptr;`
`<` | 🐱 | `--ptr;`
`+` | 😺 | `++*ptr;`
`-` | 😾 | `--*ptr;`
`.` | 😻 | `putchar(*ptr);`
`,` | 😽 | `*ptr=getchar();`
`[` | 😸 | `while (*ptr) {`
`]` | 😹 | `}`

## Implementation

`Bf` module exposes `run/2` function, accepting the input and the dialect (`:bf` or `:kitty`.)

Then it parses the input, grapheme by grapheme, maintaining the state of cells in the processes (one per a cell.) The proceses are spawn as needed.

This is the whole code of the process backbone, built on top of `Tarearbol.DynamicManager`.

```elixir
defmodule Bf.Dyno do
  use Tarearbol.DynamicManager

  @impl Tarearbol.DynamicManager
  # empty initial state is empty, run as needed
  # to slightly speed it up and replay the BF behavior change to
  #   def children_specs,
  #     do: Enum.into(0..30_000, %{}, & {&1, payload: 0, timeout: 0})
  def children_specs, do: %{}

  @impl Tarearbol.DynamicManager
  def call(:<, _from, {_id, value}), do: {:ok, value}

  @impl Tarearbol.DynamicManager
  def cast(:-, {_id, value}), do: {:replace, value - 1}
  def cast(:+, {_id, value}), do: {:replace, value + 1}
  def cast({:>, value}, {_id, _value}), do: {:replace, value}
end
```

This is it. Upon parsing the input, the parser holds the position (instruction pointer,) which plays the role of `id` for these processes. Each process carries the internal state, which is basically the data cell value. It might be retrieven via synchronous `call/3` or altered with asynchronous `cast/2`.

On seeing a new instruction, the main process either alters the injstruction pointer, or interacts with the user via 😻 or 😽 instructions, or talks to the data cell process with somewhat like `Bf.Dyno.asynch_call(pos, {:>, value})`.

When the main process sees the cell for the first time, it spawn a new process with `Bf.Dyno.put(pos, payload: 0, timeout: 0)` (value set to zero, never perform scheduled calls.) Technically, it might be using several nodes in a distributed version without much modifications to the code itself.

Below is a link to the documentation on `Tarearbol.DynamicManager` that made this project exist and brought a couple of hours full of fun developing it.

## [`Tarearbol.DynamicManager`](https://hexdocs.pm/tarearbol)

