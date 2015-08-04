defmodule Road do
  def main([file_name]) do
    doc = File.read!(file_name)
    parse_map(doc)
    |> optimal_path
  end

  # 文字列を読みやすい 3 要素のタプルのマップに変換する
  def parse_map(x) when is_list(x), do: List.to_string(x) |> parse_map
  def parse_map(x) when is_binary(x) do
    x
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(3)
    |> Enum.map(&List.to_tuple/1)
  end

  # 実際に問題を解く部分
  def shortest_step({a, b, x}, {{dist_a, path_a}, {dist_b, path_b}}) do
    opt_a1 = {dist_a + a, [{:a, a} | path_a]}
    opt_a2 = {dist_a + b + x, [{:x, x}, {:b, b} | path_b]}
    opt_b1 = {dist_b + b, [{:b, b} | path_b]}
    opt_b2 = {dist_a + a + x, [{:x, x}, {:a, a} | path_a]}
    # すべての Erlang 項は比較可能なことを思い出してください！
    # タプルの最初の要素が長さなので、このようにして並び替えできます。
    {min(opt_a1, opt_a2), min(opt_b1, opt_b2)}
  end

  # すごい Erlang 本方式，最適な経路を選ぶ
  def optimal_path(map) do
    {a, b} = List.foldl(map, {{0, []}, {0, []}}, &shortest_step/2)
    {_dist, path} = cond do
                      elem(a, 1) |> hd !== {:x, 0} -> a
                      elem(b, 1) |> hd !== {:x, 0} -> b
                    end
    Enum.reverse(path)
  end

  # optimal_path と同じ結果になるけど，こっちの方が僕にはわかりやすい
  def my_optimal_path(map) do
    {{dist_a, path_a}, {dist_b, path_b}} = List.foldl(map, {{0, []}, {0, []}}, &shortest_step/2)
    path = cond do
             dist_a < dist_b -> path_a
             dist_a > dist_b -> path_b
             # 同じ距離のときは {:x, 0} の含まれていない方を表示する
             dist_a === dist_b -> if Enum.member?(path_a, {:x, 0}), do: path_b, else: path_a
           end
    Enum.reverse(path)
  end
end
