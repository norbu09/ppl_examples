defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign_user_activity()}
  end

  def render(assigns) do
    ~H"""
    <div class="user-activity-component ml-8">
      <h2>User Activity</h2>
      <p>Active users currently viewing games</p>
      <div :for={{product_name, users} <- @user_activity}>
        <h3><%= product_name %></h3>
        <ul>
          <li :for={user <- users}><%= user.email %></li>
        </ul>
      </div>
    </div>
    """
  end

  def assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
