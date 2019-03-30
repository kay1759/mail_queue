defmodule MailQueue do
  @moduledoc """
  Documentation for MailQueue.
  """

  use GenServer
  use AMQP
  import Bamboo.Email

  @config Application.get_env(:mail_queue, __MODULE__, [])

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [])
  end

  def init(_opts) do
    {:ok, conn} = Connection.open(@config[:amqp_server])
    {:ok, chan} = Channel.open(conn)
    setup_queue(chan)

    # Limit unacknowledged messages to 10
    :ok = Basic.qos(chan, prefetch_count: 10)
    # Register the GenServer process as a consumer
    {:ok, _consumer_tag} = Basic.consume(chan, @config[:queue])
    {:ok, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  defp setup_queue(chan) do
    {:ok, _} = Queue.declare(chan, @config[:queue_error], durable: true)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    {:ok, _} = Queue.declare(chan, @config[:queue],
                             durable: true,
                             arguments: [
                               {"x-dead-letter-exchange", ""},
                               {"x-dead-letter-routing-key", @config[:queue_error]}
                             ]
                            )
    :ok = Exchange.fanout(chan, @config[:exchange], durable: true)
    :ok = Queue.bind(chan, @config[:queue], @config[:exchange])
  end

  defp consume(channel, tag, redelivered, payload) do
    payload
    |> MailQueue.Protos.Email.decode
    |> send_mail
    |> MailQueue.Mailer.deliver_later     
    :ok = Basic.ack channel, tag

  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise comsumer will stop
    # receiving messages.
    exception ->
      :ok = Basic.reject channel, tag, requeue: not redelivered
  end

  @doc """
  send an email
  """
  def send_mail(args) do
    new_email()
    |> from(args.from)
    |> to(args.to)
    |> subject(args.subject)
    |> text_body(args.text_body)
    |> html_body(args.html_body)
  end
end
