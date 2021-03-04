# Distributed Brainfuck

Reference: https://en.wikipedia.org/wiki/Brainfuck

## C equivalence, instructions

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

## Examples

```elixir
Bf.run(
  """
  😺😺😺😺 😺😺😺😺
  😸😼😺😺😺😺 😸😼😺😺😼😺😺😺😼😺😺😺😼😺🐱🐱🐱🐱😾😹 😼😺😼😺😼😾😼😼😺 😸🐱😹 🐱😾😹
  😼😼😺😺😺😺😺😻😼😾😾😾😻😺😺😺😺😺😺😺😺😺😺😻😺😺😺😺😺😺😺😺😻
  """,
  :kitty
)
#⇒ Meow
```
