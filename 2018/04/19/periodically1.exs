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

defmodule Periodically1 do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    schedule_work()
    {:ok, ExternalConnection.create()}
  end

  def handle_cast(:do_something, conn) do
    ExternalConnection.do_something(conn)
    {:noreply, conn}
  end

  def handle_info(:do_ping, conn) do
    schedule_work()
    # 外部と通信する処理をここに書く
    ExternalConnection.ping(conn)
    {:noreply, conn}
  end

  defp schedule_work() do
    Process.send_after(self(), :do_ping, 10 * 1000) # In 10 seconds
  end
end

{:ok, pid} = Periodically1.start_link
Process.sleep(25 * 1000) # 25 seconds
GenServer.cast(pid, :do_something)
IO.puts("do_somethingから10秒後ではなく，定期的なpingが5秒後に送られる")
Process.sleep(6 * 1000)
GenServer.stop(pid)
