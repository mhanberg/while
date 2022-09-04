# While

Generic reducer construct for iterating over arbitrary data structures.

This is useful for iterating over non-enumerable data without defining recursive functions manually, and allowing you to capture data at the call side by creating a closure.

## Basic Parser Example

```elixir
import While

# 👇 A: non-enumerable data
parser = %Parser{}

parser = 
  #     👇 B: condition           👇 C: data being iterated over 
  while another_token?(parser) <- parser do
    # D: returns a Parser struct that has consumed the next token
    # value is passed to the next iteration
    Parser.next_token(parser)
  end
```

## Counter Example

```elixir
counter = 0

while counter < 10 <- counter do
  counter + 1
end
```

## Real Parser Example

This is an example from the parser for my implementation of the [Monkey](https://github.com/mhanberg/monkey/tree/main/elixir) programming langauge from [Writing an Interpreter in Go](https://interpreterbook.com)

```elixir
defp parse_expression(%__MODULE__{} = parser, precedence) do
  prefix = parser.prefix_parse_functions[parser.current_token.type]

  if prefix == nil do
    parser =
      put_parser_error(
        parser,
        "no prefix parse function for #{parser.current_token.type} found"
      )

    {parser, nil}
  else
    {parser, left_expression} = prefix.(parser)

    while !is_peek_token?(parser, @token_semicolon) && precedence < peek_precedence(parser) <-
            {parser, left_expression} do
      infix = parser.infix_parse_functions[parser.peek_token.type]

      if infix == nil do
        {parser, left_expression}
      else
        parser = next_token(parser)

        infix.(parser, left_expression)
      end
    end
  end
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `while` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:while, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/while>.

