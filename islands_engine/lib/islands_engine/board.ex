defmodule IslandsEngine.Board do

  alias IslandsEngine.{Coordinate,Island}

  def new(), do: %{}

  # checking the position of island on the front-end
  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error,:overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn{key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  # check every player has used all the island types before the match
  def all_islands_positioned?(board), do:
    Enum.all?(Island.types, &(Map.has_key?(board, &1)))

  # check all the islands on the board for a match and then formulate the response
  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  def check_all_islands(board, coordinate) do
      Enum.find_value(board, :miss, fn {key, island} ->
        case Island.guess(island, coordinate) do
          {:hit, island} -> {key, island}
          :miss          -> false
        end
      end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hot, forest_check(board, key), win_check(board), board}
  end

  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.getch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  defp all_forested?(board), do:
    Enum.all?(board, fn {_key, island} -> Island.forested?(island) end)

end
