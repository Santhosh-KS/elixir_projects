defmodule EnrolmentformWeb.UserLive.Form do
  use EnrolmentformWeb, :live_view

  alias Enrolmentform.Courses
  alias Enrolmentform.Courses.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Please fill the form to enroll to the free-workshop</:subtitle>
      </.header>

      <.form for={@form} id="user-form" phx-change="validate" phx-submit="enroll">
        <.input field={@form[:name]} type="text" label="Your Name" />
        <.input field={@form[:email]} type="text" label="Valid Email address." />
        <.input field={@form[:linkedInUrl]} type="text" label="Your LinkedIn Profile URL." />
        <footer>
          <.button phx-disable-with="Enrolling..." variant="primary">Enroll!</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    user = Courses.get_user!(id)

    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, user)
    |> assign(:form, to_form(Courses.change_user(user)))
  end

  defp apply_action(socket, :new, _params) do
    user = %User{}

    socket
    |> assign(:page_title, "AI work flow for developers")
    |> assign(:user, user)
    |> assign(:form, to_form(Courses.change_user(user)))
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Courses.change_user(socket.assigns.user, user_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("enroll", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.live_action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Courses.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Courses.create_user(user_params) do
      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:info, "Woohoo! You're in! 🎉 Get ready for some awesome learning!")
          |> assign(form: to_form(Courses.change_user(%User{})))

        {:noreply, socket}

      # |> push_navigate(to: ~p"/home")}

      # |> push_navigate(to: "/home")}

      # |> push_navigate(to: return_path(socket.assigns.return_to, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _user), do: ~p"/users"
  defp return_path("show", user), do: ~p"/users/#{user}"
end
