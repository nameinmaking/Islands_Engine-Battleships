defmodule IslandsEngine.Coordinate do
  alias __MODULE__
  # module attribute to ensure both the keys are present on creation
  # to be used before the definition of the struct
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  # using range to validate the cordinate as we create it
  # returning {:error,:invalid_coordinate} if value is outside the range
  def new(row, col) when row in(@board_range) and col in (@board_range), do:
    {:ok, %Coordinate{row: row, col: col}}

  # function to return the error
  def new(_row, _col), do: {:error, :invalid_coordinate}

end
