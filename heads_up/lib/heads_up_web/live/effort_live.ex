defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, responders: 0, time: 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="effort">
      <h1>Effort Estimator</h1>
      <section>
        <button phx-click="add" phx-value-qty="3">+3</button>
        <div>
          {@responders}
        </div>
        @
        <div>
          {@time}
        </div>
        =
        <div>
          {@responders * @time}
        </div>
      </section>
    </div>
    """
  end

  def handle_event("add", %{"qty" => qty}, socket) do
    socket = update(socket, :responders, &(&1 + String.to_integer(qty)))
    {:noreply, socket}
  end
end
