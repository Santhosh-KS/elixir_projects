defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  alias HeadsUp.Incidents

  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    # IO.inspect(self(), lable: "MOUNT")
    # socket = stream(socket, :incidents, Incidents.filer_incidents())
    # IO.inspect(socket.assigns.streams.incidents, lable: "MOUNT")

    # socket =
    # attach_hook(socket, :log_stream, :after_render, fn socket ->
    # IO.inspect(socket.assigns.streams.incidents, label: "RENDER")
    # socket
    # end)
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    # IO.inspect(self(), lable: "HANDLE PARAMS")

    socket =
      socket
      |> stream(:incidents, Incidents.filer_incidents(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    # IO.inspect(self(), lable: "RENDER")

    ~H"""
    <!-- <pre>
      {inspect(@form, pretty: true)}
      {inspect(@form[:q], pretty: true)}
    </pre> -->
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
      <.filter_form form={@form}></.filter_form>
      <div class="incidents" id="incidents" phx-update="stream">
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={[
          "Priority: High to Low": "priority_desc",
          "Priority: Low to High": "priority_asc"
        ]}
      />
      <.input type="select" field={@form[:sort_by]} prompt="Sort By" options={[:priority, :name]} />
      <.link patch={~p"/incidents"}> Reset</.link>
    </.form>
    """
  end

  attr :incident, HeadsUp.Incidents.Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"} id={@id}>
      <div class="card">
        <.image image={@incident.image_path} />
        <.description description={@incident.description} />
        <.details status={@incident.status} priority={@incident.priority} />
      </div>
    </.link>
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

  def handle_event("filter", params, socket) do
    # socket =
    # socket
    # |> assign(:form, to_form(params))
    # |> stream(:incidents, Incidents.filer_incidents(params), reset: true)

    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end
