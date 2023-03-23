defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component

  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> assign_changeset()}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="save" phx-target={@myself} name="rating_form">
        <.input field={@form[:user_id]} type="hidden" />
        <.input field={@form[:product_id]} type="hidden" />
        <.input
          field={@form[:stars]}
          type="rating"
          prompt="Rating"
          options={[
            "
          ★★★★★": 5,
            "
          ★★★★": 4,
            "
          ★★★": 3,
            "
          ★★": 2,
            "
          ★": 1
          ]}
        />
        <.button phx-disable-with="Saving...">Save</.button>
      </.form>
    </div>
    """
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  def save_rating(
        %{assigns: %{product_index: product_index, product: product}} = socket,
        rating_params
      ) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def assign_changeset(%{assigns: %{rating: rating}} = socket) do
    assign(socket, :form, to_form(Survey.change_rating(rating)))
  end
end
