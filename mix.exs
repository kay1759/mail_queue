defmodule MailQueue.MixProject do
  use Mix.Project

  def project do
    [
      app: :mail_queue,
      version: "0.1.2",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      applications: [:exprotobuf, :amqp, :bamboo, :bamboo_smtp],
      mod: {MailQueue.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:amqp, "~> 3.1"},
      {:exprotobuf, "~> 1.2.17"},
      {:bamboo_smtp, "~> 4.2.2"},
      {:ex_doc, "~> 0.27", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.1"}
    ]
  end
end
