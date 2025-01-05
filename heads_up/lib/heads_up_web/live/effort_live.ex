defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    socket = assign(socket, responders: 0, minutes: 10)
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
          {@minutes}
        </div>
        =
        <div>
          {@responders * @minutes}
        </div>
      </section>

      <form phx-submit="set-minutes">
        <label>Minutes : </label>
        <input type="number" name="minutes" value={@minutes} />
      </form>
    </div>
    """
  end

  def handle_event("add", %{"qty" => qty}, socket) do
    socket = update(socket, :responders, &(&1 + String.to_integer(qty)))
    {:noreply, socket}
  end

  def handle_event("set-minutes", %{"minutes" => min}, socket) do
    socket = assign(socket, :minutes, String.to_integer(min))
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :responders, &(&1 + 4))}
  end
end
