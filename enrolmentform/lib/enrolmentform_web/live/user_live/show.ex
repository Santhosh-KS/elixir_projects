defmodule EnrolmentformWeb.UserLive.Show do
  use EnrolmentformWeb, :live_view

  alias Enrolmentform.Courses

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        User Name: "{@user.name}"
        <:subtitle>This is a user record from your database with ID: {@user.id}</:subtitle>
        <:actions>
          <.button navigate={~p"/users"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/users/#{@user}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit user
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@user.name}</:item>
        <:item title="Email">{@user.email}</:item>
        <:item title="LinkedIn URL">{@user.linkedInUrl}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show User")
     |> assign(:user, Courses.get_user!(id))}
  end
end
