# Distributed Brainfuck

Reference: https://en.wikipedia.org/wiki/Brainfuck

## C equivalence

brainfuck | command C equivalent
--------- | --------------------
‹Program Start› | `char array[30000] = {0}; char *ptr = &array[0];`
`>` | `++ptr;`
`<` | `--ptr;`
`+` | `++*ptr;`
`-` | `--*ptr;`
`.` | `putchar(*ptr);`
`,` | `*ptr=getchar();`
`[` | `while (*ptr) {`
`]` | `}`

## Implementation