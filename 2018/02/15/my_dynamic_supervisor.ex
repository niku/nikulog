defmodule MyWorker do
  use GenServer

  #
  # 2-2.  MyDynamicSupervisor.start_child から呼び出される
  #
  def start_link(implicit_arg, arg1, arg2, options \\ []) do
    IO.puts "MyWorker.start_link: #{inspect {arg1, arg2, options}}"
    GenServer.start_link(__MODULE__, [implicit_arg, arg1, arg2], options)
  end

  #
  # 2-3.
  #
  def init(args) do
    IO.puts "MyWorker.init: #{inspect args}"
    {:ok, args}
  end
end

defmodule MyDynamicSupervisor do
  use DynamicSupervisor

  #
  # 1-1. 1回目エントリポイント
  # DynamicSupervisor.start_link(__MODULE__, arg, []) は init/1 のコールバックを呼びだす
  #
  def start_link(arg) do
    IO.puts "MyDynamicSupervisor.start_link: #{inspect arg}"

    DynamicSupervisor.start_link(__MODULE__, arg, [])
  end

  #
  # 2-1. 2回目エントリポイント
  def start_child(pid, arg1, arg2) do
    IO.puts "MyDynamicSupervisor.start_child: #{inspect {arg1, arg2}}"

    spec = Supervisor.Spec.worker(MyWorker, [arg1, arg2])
    IO.puts "spec: #{inspect spec}"

    #
    # spec には extra_arguments が含まれていないが
    # DynamicSupervisor.start_child(pid, spec)
    # で呼びだした Worker の start_link の引数には extra_arguments が追加されているのに注目せよ
    #
    DynamicSupervisor.start_child(pid, spec)
  end

  #
  # 1-2. 初期化
  # extra_arguments を設定した場合，start_child で worker を作ると引数の先頭に extra_arguments が追加される
  #
  def init(implicit_arg) do
    IO.puts "MyDynamicSupervisor.init: #{inspect implicit_arg}"

    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [implicit_arg]
    )
  end
end

IO.puts "**** MyDynamicSupervisor.start_link ****"
{:ok, dynamic_supervisor_pid} = MyDynamicSupervisor.start_link("an implicit arg")
IO.puts ""
IO.puts "**** MyDynamicSupervisor.start_child ****"
{:ok, worker_pid} = MyDynamicSupervisor.start_child(dynamic_supervisor_pid, "arg1", "arg2")
