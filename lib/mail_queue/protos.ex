defmodule MailQueue.Protos do
  @moduledoc """
  Email format for Protocol Buffer 
  """

  use Protobuf, """
    message Email {
      required string from = 1;
      required string to = 2; 
      required string subject = 3;
      optional string text_body = 4; 
      optional string html_body = 5;
    }
  """
end
