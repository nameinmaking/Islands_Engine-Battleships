defmodule IslandsEngine.Guesses do
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  # Using MapSet to enforce automatic uniqueness of data
  def new(), do:
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}

end
