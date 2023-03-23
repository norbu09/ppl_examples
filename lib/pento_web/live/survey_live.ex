defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.SurveyLive.Component
  alias PentoWeb.RatingLive.Show
  alias PentoWeb.{DemographicLive, RatingLive, Endpoint}
  alias Pento.Survey

  @survey_results_topic "survey_results"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_products()
     |> assign_demographic}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <Component.hero content="Survey">
        Please fill out our survey
      </Component.hero>
      <%= if @demographic do %>
        <DemographicLive.Show.details demographic={@demographic} />
        <hr />
        <br />
        <RatingLive.Index.product_list products={@products} current_user={@current_user} />
      <% else %>
        <.live_component
          module={DemographicLive.Form}
          id="demographic-form"
          current_user={@current_user}
        />
      <% end %>
    </section>
    """
  end

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  @impl true
  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  defp handle_rating_created(
         %{assigns: %{products: products}} = socket,
         updated_product,
         product_index
       ) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      List.replace_at(products, product_index, updated_product)
    )
  end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  def assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  def product_rating(assigns) do
    ~H"""
    <div><%= @product.name %></div>
    <%= if rating = List.first(@product.ratings) do %>
      <Show.stars rating={rating} />
    <% else %>
      <h3><%= @product.name %> rating form coming soon!</h3>
    <% end %>
    """
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(
      socket,
      :demographic,
      Survey.get_demographic_by_user(current_user)
    )
  end

  defp list_products(user) do
    Survey.list_products_with_user_rating(user)
  end
end
