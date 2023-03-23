defmodule Pento.Promo do
  alias Pento.Promo.Recipient
  require Logger

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(recipient, _attrs) do
    # send email to promo recipient
    Logger.debug("sending email to: #{inspect(recipient)}")
    {:ok, %Recipient{}}
  end
end
