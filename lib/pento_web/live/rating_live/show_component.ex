defmodule PentoWeb.RatingLive.Show do
  use Phoenix.Component
  use Phoenix.HTML

  attr :rating, :any, required: true

  def stars(assigns) do
    ~H"""
    <div>
      <%= @rating.stars
      |> filled_stars()
      |> Enum.concat(unfilled_stars(@rating.stars))
      |> Enum.join(" ")
      |> raw() %>
    </div>
    """
  end

  def filled_stars(stars) do
    List.duplicate("&#x2605;", stars)
  end

  def unfilled_stars(stars) do
    List.duplicate("&#x2606;", 5 - stars)
  end
end
