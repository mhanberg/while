defmodule While do
  @moduledoc """
  Generic reducer construct for iterating over arbitrary data structures.

  This is useful for iterating over non-enumerable data without defining recursive functions manually, and allowing you to capture data at the call side by creating a closure.

  ## Parser Example

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
  """
  defmacro while(expression, do: block) do
    {:<-, _, [condition, acc]} = expression

    predicate =
      quote do
        fn unquote(acc) ->
          _ = unquote(acc)
          res = unquote(condition)

          body = fn unquote(acc) ->
            _ = unquote(acc)

            unquote(block)
          end

          {res, body}
        end
      end

    quote do
      do_while(unquote(acc), unquote(predicate))
    end
  end

  def do_while(acc, predicate) do
    {condition, wrapped_body} = predicate.(acc)

    if condition do
      acc = wrapped_body.(acc)

      do_while(acc, predicate)
    else
      acc
    end
  end
end
