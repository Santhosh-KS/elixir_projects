defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents

  def mount(_params, _session, socket) do
    socket = assign(socket, :incidents, Incidents.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="incident-index">
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

  attr :status, :atom, values: [:pending, :resolved, :canceled], default: :pending

  def badge(assigns) do
    ~H"""
    <div class="badge">
      {@status}
    </div>
    """
  end

  def priority(assigns) do
    ~H"""
    <div class="rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border text-lime-600 border-lime-600">
      {@priority}
    </div>
    """
  end
end
