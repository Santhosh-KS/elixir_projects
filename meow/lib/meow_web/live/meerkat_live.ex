defmodule MeowWeb.MeerkatLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="table-container">
      <.table id="MyMeerkatsTable" rows={@meerkats}>
        <:col :let={%Meow.Meerkats.Meerkat{:id => id}} label="ID">{id}</:col>
        <:col :let={%Meow.Meerkats.Meerkat{:name => name}} label="Name">{name}</:col>
      </.table>
    </div>
    <!-- <div id="table-container">
      <table>
        <tbody>
          <%= if assigns[:error_message] do %>
            <tr>
              <td colspan="6">{@error_message}</td>
            </tr>
          <% else %>
            <%= for meerkat <- @meerkats do %>
              <tr data-test-id={meerkat.id}>
                <td>{meerkat.id}</td>
                <td>{meerkat.name}</td>
              </tr>
            <% end %>
          <% end %>
        </tbody>
      </table>
    </div> -->
    """
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign_meerkats(socket)}
  end

  defp assign_meerkats(socket) do
    assign(socket, :meerkats, Meerkats.list_meerkats())
  end
end
