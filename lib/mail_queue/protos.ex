defmodule MailQueue.Protos do
  @moduledoc """
  Email format for Protocol Buffer 
  """

  use Protobuf, """
    message Email {
      string from = 1;
      string to = 2; 
      string subject = 3;
      string text_body = 4; 
      string html_body = 5; 
    }
  """
end
