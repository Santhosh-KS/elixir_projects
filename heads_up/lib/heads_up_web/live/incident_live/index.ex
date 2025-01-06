defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents

  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
      <.headline>
        <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
        <:tagline :let={vibe}>
          Thanks for pitching in. {vibe}
        </:tagline>
        <:tagline :let={vibe}>
          Next tagline. {vibe}
        </:tagline>
      </.headline>
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end

  attr :incident, HeadsUp.Incident, required: true

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <.image image={@incident.image_path} />
      <.description description={@incident.description} />
      <.details status={@incident.status} priority={@incident.priority} />
    </div>
    """
  end

  def details(assigns) do
    ~H"""
    <div class="details">
      <.badge status={@status} />
      <.priority priority={@priority} />
    </div>
    """
  end

  def image(assigns) do
    ~H"""
    <img src={@image} />
    """
  end

  def description(assigns) do
    ~H"""
    <h2>{@description}</h2>
    """
  end

  attr :priority, :atom, required: true

  def priority(assigns) do
    ~H"""
    <div class="priority">
      {@priority}
    </div>
    """
  end
end
