defmodule Elixart do

  # Hello World
  def hello do
    "Hello World"
  end

  # Capitalize
  def capitalize(str) do
    Enum.map_join(String.split(str), " ", fn word -> String.capitalize(word) end)
  end

  # Ping Pong
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

  # Process Ring
  def worker(%{state: :initializing} = data) do
    receive do
      {:next, pid} ->
        worker(%{data | state: :working, next_worker: pid })

      _ ->
        IO.puts :stderr, "Unexpected message received."
    end
  end

  def worker(%{state: :working} = data) do
    %{
      initiator: initiator,
      job: job,
      next_worker: next_worker,
      } = data
    receive do
      {:calc, 0, acc} ->
        send initiator, {:result, job.(acc)}
        send self(), :done
        worker(data)

      {:calc, rest_hops, acc} ->
        send next_worker, {:calc, rest_hops - 1, job.(acc)}
        worker(data)

      :done ->
        send next_worker, :done
        exit(:normal)

      _ ->
        IO.puts :stderr, "Unexpected message received."
    end
  end

  defp create_ring(initiator, job, size) do
    initial_data = %{
      initiator: initiator,
      job: job,
      next_worker: nil,
      state: :initializing,
    }
    entry_point = spawn_link(Elixart, :worker, [initial_data])
    last_worker = create_workers(initiator, job, size - 1, entry_point)
    send entry_point, {:next, last_worker}
    entry_point
  end

  defp create_workers(_, _, 0, last_worker) do
    last_worker
  end

  defp create_workers(initiator, job, count, next_worker) do
    data = %{
      initiator: initiator,
      job: job,
      next_worker: next_worker,
      state: :working,
    }
    new_worker = spawn_link(Elixart, :worker, [data])
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
