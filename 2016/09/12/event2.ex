defmodule Event do
  defmodule State, do: defstruct server: nil, name: "", to_go: 0

  # Because Erlang is limited to about 49 days (49*24*60*60*1000) in
  # milliseconds, the following function is used.
  def normalize(n) do
    limit = 49*24*60*60
    [rem(n, limit) | List.duplicate(limit, div(n, limit))]
  end

  # Loop uses a list for times in order to go around the ~49 days limit
  # on timeouts.
  def loop(state = %State{server: server, to_go: [t|next]}) do
    receive do
      {server, ref, :cancel} ->
        send(server, {ref, :ok})
      after t * 1000 ->
        case next do
          [] -> send(server, {:done, state.name})
          [_x] -> loop(%{state | to_go: next})
        end
    end
  end
end
