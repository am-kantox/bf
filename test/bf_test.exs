defmodule BfTest do
  use ExUnit.Case
  doctest Bf

  import ExUnit.CaptureIO

  setup do
    Bf.Dyno.restart()
    Process.sleep(100)
    :ok
  end

  test "map/1" do
    assert "😺😺😼😺😺😺😺😺😸🐱😺😼😾😹😺😺😺😺😺😺😺😺😸🐱😺😺😺😺😺😺😼😾😹🐱😻" ==
             Bf.map("++>+++++ [<+>-] ++++++++ [<++++++>-] <.")

    assert "++>+++++[<+>-]++++++++[<++++++>-]<." ==
             Bf.unmap("😺😺😼😺😺😺😺😺 😸🐱😺😼😾😹 😺😺😺😺😺😺😺😺 😸🐱😺😺😺😺😺😺😼😾😹 🐱😻")
  end

  test "addition example from Wikipedia" do
    assert "7\n" ==
             capture_io(fn ->
               Bf.run("++>+++++[<+>-]++++++++[<++++++>-]<.")
             end)
  end

  test "Hello world example from Wikipedia" do
    assert "Hello World!\n\n" ==
             capture_io(fn ->
               Bf.run("""
               ++++ ++++
               [>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]
               >>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
               """)
             end)
  end

  test "Meow (:bf)" do
    assert "Meow\n" ==
             capture_io(fn ->
               Bf.run("""
               ++++ ++++
               [>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]
               >>+++++.>---.++++++++++.++++++++.
               """)
             end)
  end

  test "Meow (:kitty)" do
    assert "Meow\n" ==
             capture_io(fn ->
               Bf.run(
                 """
                 😺😺😺😺 😺😺😺😺
                 😸😼😺😺😺😺 😸😼😺😺😼😺😺😺😼😺😺😺😼😺🐱🐱🐱🐱😾😹 😼😺😼😺😼😾😼😼😺 😸🐱😹 🐱😾😹
                 😼😼😺😺😺😺😺😻😼😾😾😾😻😺😺😺😺😺😺😺😺😺😺😻😺😺😺😺😺😺😺😺😻
                 """,
                 :kitty
               )
             end)
  end
end
