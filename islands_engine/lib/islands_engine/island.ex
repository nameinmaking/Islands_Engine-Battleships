defmodule IslandsEngine.Island do
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  # using MapSet as at the time of checking the order of insertion won't matter
  # Example:
  # iex> MapSet.equal?(MapSet.new([1,2]), MapSet.new([2,1]))
  # true
  # def new(), do:
  #   %Island{coordinates: MapSet.new(), hit_coordinates: MapSet.new()}

  def new(type, %Coordinate{} = upper_left) do
    with [_|_] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
    do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  # square shaped islands
  defp offsets(:square), do: [{0,0},{0,1},{1,0},{1,1}]

  # atoll shaped islands
  defp offsets(:atoll), do: [{0,0},{0,1},{1,1},{2,0},{2,1}]

  # simple dot shaped islands
  defp offsets(:dot), do: [{0,0}]

  # l-shaped islands
  defp offsets(:l_shape), do: [{0,0},{1,0},{2,0},{2,1}]

  # s-shaped islands
  defp offsets(:s_shape), do: [{0,1},{0,2},{1,0},{1,1}]

  # all other shaped islands
  defp offsets(_), do: {:error, :invalid_island_type}

  # returns either the complete set of coordinates or an error tuple,
  # if we get an invalid island coordinate
  defp add_coordinates(offsets, upper_left) do
    # Enum.reduce will not work as it cannot handle invalid coordinate inputs
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  # check to see if a coordinate is valid
  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates,coordinate)}
      {:error, :invalid_coordinate} ->
        {:halt,{:error, :invalid_coordinate}}
    end
  end

  # function to check if the island's overlap each other (Additioanl backend check)
  def overlaps?(existing_island, new_island), do:
    not MapSet.disjoint?(existing_island.coordinates,new_island.coordinates)

  # check if guessed island is a hit/miss
  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}
      false -> :miss
    end
  end

  # check if the hit island is forested
  def forested?(island), do:
    MapSet.equal?(island.coordinates, island.hit_coordinates)

  # All the valid island types
  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

end
