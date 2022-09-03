defmodule WhileTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  import While

  test "works" do
    counter = 0
    acc = []

    puts =
      capture_io(fn ->
        {counter, list} =
          while counter < 10 <- {counter, acc} do
            IO.puts("hi")
            counter = counter + 1

            {counter, [counter | acc]}
          end

        assert 10 == counter
        assert [10, 9, 8, 7, 6, 5, 4, 3, 2, 1] == list
      end)

    assert puts == """
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           """
  end

  test "different acc" do
    counter = 0

    puts =
      capture_io(fn ->
        thing =
          while counter < 10 <- counter do
            IO.puts("hi")
            counter = counter + 1

            counter
          end

        assert 10 == thing
      end)

    assert puts == """
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           hi
           """
  end

  test "condition defines identifier" do
    counter = 0

    puts =
      capture_io(fn ->
        thing =
          while truth? = counter < 10 <- counter do
            IO.puts(inspect(truth?))

            counter + 1
          end

        assert 10 == thing
      end)

    assert puts == """
           true
           true
           true
           true
           true
           true
           true
           true
           true
           true
           """
  end
end
