defmodule Linkmon do
  def start_critic do
    spawn(__MODULE__, :critic, [])
  end

  def start_critic2 do
    spawn(__MODULE__, :restarter, [])
  end

  def restarter do
    :erlang.process_flag(:trap_exit, true)
    pid = spawn_link(__MODULE__, :critic2, [])
    Process.register(pid, :critic)
    receive do
      {:EXIT, pid, :normal} -> :ok   # not a crash
      {:EXIT, pid, :shutdown} -> :ok # manual termination, not a crash
      {:EXIT, pid, _} -> restarter
    end
  end

  def judge(pid, band, album) do
    send(pid, {self, {band, album}})
    receive do
      {pid, criticism} -> criticism
    after 2000 ->
      :timeout
    end
  end

  def judge2(band, album) do
    ref = make_ref
    send(:critic, {self, ref, {band, album}})
    receive do
      {ref, criticism} -> criticism
    after 2000 ->
      :timeout
    end
  end

  def critic do
    receive do
      {from, {"Rage Against the Turing Machine", "Unit Testify"}} ->
        send(from, {self, "They are great!"})
      {from, {"System of a Downtime", "Memoize"}} ->
        send(from, {self, "They're not Johnny Crash but they're good."})
      {from, {"Jonney Crash", "The Token Ring of Fire"}} ->
        send(from, {self, "Simply incredible."})
      {from, {_band, _album}} ->
        send(from, {self, "They are terrible!"})
    end
    critic
  end

  def critic2 do
    receive do
      {from, ref, {"Rage Against the Turing Machine", "Unit Testify"}} ->
        send(from, {ref, "They are great!"})
      {from, ref, {"System of a Downtime", "Memoize"}} ->
        send(from, {ref, "They're not Johnny Crash but they're good."})
      {from, ref, {"Jonney Crash", "The Token Ring of Fire"}} ->
        send(from, {ref, "Simply incredible."})
      {from, ref, {_band, _album}} ->
        send(from, {ref, "They are terrible!"})
    end
    critic2
  end
end
