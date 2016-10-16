defmodule Elixart do

  def hello do
    "Hello World"
  end

  def capitalize(str) do
    Enum.map_join(String.split(str) , " ", fn word -> String.capitalize(word) end)
  end

  def pong do
    receive do
      {:ping, from} -> send from, :pong
    end
  end

  def stateful(address) do
    receive do
      {:address, target} ->
        stateful(target)
      :ping ->
        send address, :pong
        stateful(address)
    end
  end

  def worker(initiator, job, next_worker) do
    receive do
      {:calc, 0, acc} ->
        send initiator, {:result, job.(acc)}
        send self(), :done
        worker(initiator, job, next_worker)

      {:calc, rest_hops, acc} ->
        send next_worker, {:calc, rest_hops - 1, job.(acc)}
        worker(initiator, job, next_worker)

      :done ->
        send next_worker, :done
        exit(:normal)

      _ -> IO.puts "i am from worker"
    end
  end

  def entry_point(initiator, job) do
    receive do
      {:next ,pid} -> worker(initiator, job, pid)
      _ -> IO.puts "i am from entry point"
    end
  end

  defp create_ring(initiator, job, size) do
    entry_point = spawn_link(Elixart, :entry_point, [initiator, job])
    last_worker = create_workers(initiator, job, size - 1, entry_point)
    send entry_point, {:next, last_worker}
    entry_point
  end

  defp create_workers(_, _, count, last_worker) when count == 0 do
    last_worker
  end

  defp create_workers(initiator, job, count, next_worker) do
    new_worker = spawn_link(Elixart, :worker, [initiator, job, next_worker])
    create_workers(initiator, job, count - 1, new_worker)
  end

  def calculate(job: job, wc: worker_count, hc: hop_count, init: init_value) do
    entry_point = create_ring(self(), job, worker_count)
    send entry_point, {:calc, hop_count, init_value}
    receive do
      {:result, value} -> value
    after
      500 -> raise "Something went wrong."
    end
  end
end
