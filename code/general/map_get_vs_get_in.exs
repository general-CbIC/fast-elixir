defmodule MapGet.MapGet2 do
  def map_get(keys, map) do
    keys
    |> Enum.map(fn key ->
      Map.get(map, key)
    end)
  end
end

defmodule MapGet.MapGet3 do
  def map_get(keys, map) do
    keys
    |> Enum.map(fn key ->
      Map.get(map, key, nil)
    end)
  end
end

defmodule MapGet.GetIn2 do
  def map_get(keys, map) do
    keys
    |> Enum.map(fn key ->
      get_in(map, [key])
    end)
  end
end

defmodule MapGet.Benchmark do
  @keys %{
    "Large (30,000 items)" => 1..30_000,
    "Medium (3,000 items)" => 1..1_000,
    "Small (30 items)" => 1..10
  }

  def benchmark do
    Benchee.run(
      %{
        "Map.get/2" => fn enumerator -> bench_func(enumerator, MapGet.MapGet2) end,
        "Map.get/3" => fn enumerator -> bench_func(enumerator, MapGet.MapGet3) end,
        "get_in/2" => fn enumerator -> bench_func(enumerator, MapGet.GetIn2) end
      },
      time: 10,
      inputs: @keys,
      print: [fast_warning: false]
    )
  end

  def map do
    1..50_000
    |> Enum.reduce(%{}, fn num, acc ->
      Map.put(acc, num, num)
    end)
  end

  def bench_func(enumerator, module) do
    module.map_get(enumerator, map())
  end
end

MapGet.Benchmark.benchmark()
