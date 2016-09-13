defmodule Event do
  defmodule State, do: defstruct server: nil, name: "", to_go: 0

  def start(event_name, delay) do
    spawn(__MODULE__, :init, [self, event_name, delay])
  end

  def start_link(event_name, delay) do
    spawn_link(__MODULE__, :init, [self, event_name, delay])
  end

  # event's innerds
  def init(server, event_name, delay) do
    loop(%State{server: server, name: event_name, to_go: normalize(delay)})
  end

  def cancel(pid) do
    # Monitor in case the process is already dead.
    ref = Process.monitor(pid)
    send(pid, {self, ref, :cancel})
    receive do
      {ref, :ok} ->
        Process.demonitor(ref, [:flush])
        :ok
      {:DOWN, ref, :process, pid, _reason} ->
        :ok
    end
  end

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
