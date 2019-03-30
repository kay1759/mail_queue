defmodule MailQueue.MixProject do
  use Mix.Project

  def project do
    [
      app: :mail_queue,
      version: "0.1.0",
      elixir: "~> 1.8",
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
      {:amqp, "~> 1.1"},
      {:exprotobuf, "~> 1.2.9"},
      {:bamboo, "~> 1.2"},
      {:bamboo_smtp, "~> 1.6.0"},
      {:ex_doc, "~> 0.19.3", only: :dev},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.0"}
    ]
  end
end
