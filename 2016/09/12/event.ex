defmodule Event do
  defmodule State, do: defstruct server: nil, name: "", to_go: 0

  def loop(state = %State{server: server}) do
    receive do
      {server, ref, :cancel} ->
        send(server, {ref, :ok})
      after state.to_go * 1000 ->
        send(server, {:done, state.name})
    end
  end
end
