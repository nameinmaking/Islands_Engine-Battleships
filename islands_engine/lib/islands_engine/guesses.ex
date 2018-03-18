defmodule IslandsEngine.Guesses do
  alias __MODULE__
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  # Using MapSet to enforce automatic uniqueness of data
  def new(), do:
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  # When the guess hits a target ship/island
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate), do:
    update_in(guesses.hits, &MapSet.put(&1, coordinate))

  # When the guess misses a target ship/island
  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate), do:
  update_in(guesses.misses, &MapSet.put(&1, coordinate))

end
