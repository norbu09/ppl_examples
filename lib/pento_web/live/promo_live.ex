defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> assign_changeset()}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Send Your Promo Code to a Friend
      <:subtitle>promo code for 10% off their first game purchase!</:subtitle>
    </.header>
    <div>
      <.simple_form for={@form} id="promo-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:first_name]} type="text" label="First Name" />
        <.input field={@form[:email]} type="email" label="Email" phx-debounce="blur" />
        <:actions>
          <.button phx-disable-with="Sending...">Send Promo</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:form, to_form(Promo.change_recipient(recipient)))
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))}
  end
end
