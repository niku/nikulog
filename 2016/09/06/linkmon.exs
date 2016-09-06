defmodule Linkmon do
  def start_critic do
    spawn(__MODULE__, :critic, [])
  end

  def judge(pid, band, album) do
    send(pid, {self, {band, album}})
    receive do
      {pid, criticism} -> criticism
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
end
