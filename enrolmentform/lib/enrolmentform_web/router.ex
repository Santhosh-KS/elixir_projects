defmodule EnrolmentformWeb.Router do
  use EnrolmentformWeb, :router

  import EnrolmentformWeb.AdminAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EnrolmentformWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EnrolmentformWeb do
    pipe_through :browser

    # get "/", PageController, :home
    live "/", UserLive.Home, :home
    live "/home", UserLive.Home, :home
    live "/users/new", UserLive.Form, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", EnrolmentformWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:enrolmentform, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EnrolmentformWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", EnrolmentformWeb do
    pipe_through [:browser, :require_authenticated_admin]

    live_session :require_authenticated_admin,
      on_mount: [{EnrolmentformWeb.AdminAuth, :require_authenticated}] do
      live "/users", UserLive.Index, :index
      live "/users/:id", UserLive.Show, :show
      live "/users/:id/edit", UserLive.Form, :edit
      live "/admins/settings", AdminLive.Settings, :edit
      live "/admins/settings/confirm-email/:token", AdminLive.Settings, :confirm_email
    end

    post "/admins/update-password", AdminSessionController, :update_password
  end

  scope "/", EnrolmentformWeb do
    pipe_through [:browser]

    live_session :current_admin,
      on_mount: [{EnrolmentformWeb.AdminAuth, :mount_current_scope}] do
      live "/admins/register", AdminLive.Registration, :new
      live "/admins/log-in", AdminLive.Login, :new
      live "/admins/log-in/:token", AdminLive.Confirmation, :new
    end

    post "/admins/log-in", AdminSessionController, :create
    delete "/admins/log-out", AdminSessionController, :delete
  end
end
