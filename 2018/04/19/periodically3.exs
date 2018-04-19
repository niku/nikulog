defmodule ExternalConnection do
  def create do
    spawn_link __MODULE__, :loop, []
  end

  def ping(pid) do
    send(pid, :ping)
  end

  def do_something(pid) do
    send(pid, :do_something)
  end

  def loop do
    IO.puts("#{Time.utc_now}: connection created")
    do_loop()
  end

  defp do_loop do
    receive do
      :ping ->
        IO.puts("#{Time.utc_now}: connection refreshed by ping")
      :do_something ->
        IO.puts("#{Time.utc_now}: connection refreshed by do_something")
    end
    do_loop()
  end
end

defmodule Periodically3 do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, ExternalConnection.create(), 10 * 1000}
  end

  def handle_cast(:do_something, conn) do
    ExternalConnection.do_something(conn)
    {:noreply, conn, 10 * 1000}
  end

  def handle_info(:timeout, conn) do
    # 外部と通信する処理をここに書く
    ExternalConnection.ping(conn)
    {:noreply, conn, 10 * 1000}
  end
end

{:ok, pid} = Periodically3.start_link
Process.sleep(25 * 1000) # 25 seconds
GenServer.cast(pid, :do_something)
IO.puts("do_somethingから10秒後にpingが送られる")
Process.sleep(11 * 1000)
GenServer.stop(pid)
