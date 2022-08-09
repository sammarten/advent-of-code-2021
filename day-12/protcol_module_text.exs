defprotocol MyProtocol do
  def print(value)

  # def parse_cert_from_string(s) do
  #   IO.puts("Parsing cert from string #{s}...")
  # end
end

defmodule A do
  defstruct []
end

defmodule B do
  defstruct []
end

defimpl MyProtocol, for: A do
  def print(_), do: IO.puts("Printing A...")
end

defimpl MyProtocol, for: B do
  def print(_), do: IO.puts("Printing B...")
end

a = %A{}
b = %B{}

MyProtocol.print(a)
MyProtocol.print(b)
