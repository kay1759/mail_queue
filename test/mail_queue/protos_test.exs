defmodule MailQueue.ProtosTest do
  use ExUnit.Case
  doctest MailQueue.Protos

  test "struct email" do
    email = MailQueue.Protos.Email.new(
      from: "sender@sending.com",
      to: "receiver@receivieng.com",
      subject: "Test Subject",
      text_body: "This is Text Body Content\nText Body Content!",
      html_body: "This is HTML Body Content\nHTML Body Content!",
    )
    
    assert "sender@sending.com" == email.sender
    assert "receiver@receivieng.com" == email.receiver
    assert "Test Subject" == email.subject
    assert "This is Text Body Content\nText Body Content!" == email.text_body
    assert "This is HTML Body Content\nHTML Body Content!" == email.html_body
  end

  test "pack and unpack struct email" do
    email = MailQueue.Protos.Email.new(
      from: "sender@sending.com",
      to: "receiver@receivieng.com",
      subject: "Test Subject",
      text_body: "This is Text Body Content\nText Body Content!",
      html_body: "This is HTML Body Content\nHTML Body Content!",
    )

    unpacked = email
    |> MailQueue.Protos.Email.encode
    |> MailQueue.Protos.Email.decode

    assert "sender@sending.com" == unpacked.sender
    assert "receiver@receivieng.com" == unpacked.receiver
    assert "Test Subject" == unpacked.subject
    assert "This is Text Body Content\nText Body Content!" == unpacked.text_body
    assert "This is HTML Body Content\nHTML Body Content!" == unpacked.html_body
  end

  test "pack and unpack struct email without html_body" do
    email = MailQueue.Protos.Email.new(
      from: "sender@sending.com",
      to: "receiver@receivieng.com",
      subject: "Test Subject",
      text_body: "This is Text Body Content\nText Body Content!"
    )

    unpacked = email
    |> MailQueue.Protos.Email.encode
    |> MailQueue.Protos.Email.decode

    assert "sender@sending.com" == unpacked.sender
    assert "receiver@receivieng.com" == unpacked.receiver
    assert "Test Subject" == unpacked.subject
    assert "This is Text Body Content\nText Body Content!" == unpacked.text_body
  end
end


