use Mix.Config

config :mail_queue, MailQueue,
  amqp_server: "amqp://app:app@172.23.17.5"

config :mail_queue, MailQueue.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username: "myuser@mydomain.com",
  password: "mypassword",
  tls: :if_available,
  ssl: false,
  retries: 1
