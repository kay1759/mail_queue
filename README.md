# Mail Queue with RabbitMQ and Protocol Buffer

## Description:
* Take data from a RabbitMQ queue and send mail.


## Environment:
Programing environment is as below.

* Ubuntu 18.04.1 LTS
* Erlang 21.2
* Elixir 1.8.1


## Application Installation Instructions:

    git clone git@github.com:kay1759/mail_queue.git
    cd mail_queue
    ***** prepare <env>.exs files in config directory *****
    mix deps.get

## Exapmle for <env>.exs,  ex: dev.exs :

    use Mix.Config

    config :mail_queue, MailQueue.Worker,
      amqp_server: "amqp://guest:guest@rabbitmq_server"

    config :mail_queue, MailQueue.Mailer,
      adapter: Bamboo.SMTPAdapter,
      server: "smtp.gmail.com",
      port: 587,
      username: "your_gmail_account@gmail.com",
      password: "your_password",
      tls: :if_available,
      ssl: false,
      retries: 1


## Operating Instructions:

### Data Format:
    message Email {
      required string from = 1;
      required string to = 2; 
      required string subject = 3;
      optional string text_body = 4; 
      optional string html_body = 5;
    }

### Usage:
    Packed with 'Protocol Buffer' and then enqueue to RabbitMQ

### deploy:
    Prepare 'prod.exs' in the config directory.

    mix distillery.init
    MIX_ENV=prod mix distillery.release --env=prod

    send '_build/prod/rel/mail_queue/releases/0.1.0/mail_queue.tar.gz' to server

    Decompress mail_queue.tar.gz in /your/directory

    /your/directory/bin/mail_queue start

## References:
- [Protocol Buffers Official](https://developers.google.com/protocol-buffers/)
- [clojusc/protobuf (Elixir Protocol Buffer library)](https://github.com/clojusc/protobuf)
- [pma/amqp (Elixir AMQP client)](https://github.com/pma/amqp)
- [thoughtbot/bamboo (Elixir Mail client)](https://github.com/thoughtbot/bamboo)

## Licence:

[MIT]

## Author

[Katsuyoshi Yabe](https://github.com/kay1759)

